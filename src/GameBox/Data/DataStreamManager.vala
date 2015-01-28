namespace GameBox.Game
{
    /**
     * Manages a stream system to read data from an InputStream and write it
     * to an OutputStream. This class exposes a flexible IO interface to manage
     * data from streams.
     *
     * This manager is intended to read from or write to a file or stream that
     * stores specific data (i.e. an XML-file) that will be parsed in this
     * class. If content gets modified, it can be saved with Save() back to the
     * file or registered OutputStream.
     *
     * Override the Write() and Parse() methods in your derivatives to implement
     * a specific DataStreamManager that handles your data format.
     *
     * To create a DataStreamManager from file, use the from_file() constructor.
     *
     * You can also manually create input and output streams and pass it to this
     * class. Use the from_input_stream() and from_output_stream() constructor
     * for that purpose (or other constructors that combine these).
     *
     * Streams are kept alive until the manager is destructed or you call
     * manually the release functions ReleaseInputStream(),
     * ReleaseOutputStream() or ReleaseStreams().
     */
    public abstract class DataStreamManager
    {
        /**
         * Instantiates a new DataStreamManager.
         *
         * Creates a DataStreamManager without any input/output streams.
         *
         * You can register input/output streams via the RegisterInputStream()
         * and RegisterOutputStream() functions.
         */
        protected DataStreamManager()
        {
            this.from_nullable_input_output_stream(null, null);
        }

        /**
         * Instantiates a new DataStreamManager.
         *
         * Creates a DataStreamManager from file with read and write access
         * (if supported, if not all access-types are supported these feature
         * will be missing and not usable).
         *
         * @param path   The path to the file to initialize from.
         * @throws Error Thrown when opening the file on path failed.
         */
        protected DataStreamManager.from_file(string path) throws Error
        {
            File file = File.new_for_path(path);
            var stream = file.open_readwrite();

            this.from_nullable_input_output_stream(
                stream.input_stream, stream.output_stream);
        }

        /**
         * Instantiates a new DataStreamManager.
         *
         * When instantiating it from an InputStream stream, the manager is
         * initialized with the data from the given InputStream.
         * Reset() is available, but Save() not.
         *
         * @param stream The InputStream to initialize from.
         */
        protected DataStreamManager.from_input_stream(InputStream stream)
        {
            this.from_nullable_input_output_stream(stream, null);
        }

        /**
         * Instantiates a new DataStreamManager.
         *
         * When instantiating it from an IO stream, the manager is
         * initialized with the data from the InputStream of the given IOStream.
         * Save() and Reset() are both available.
         *
         * @param stream The IOStream to initialize from.
         */
        protected DataStreamManager.from_io_stream(IOStream stream)
        {
            this.from_nullable_input_output_stream(
                stream.input_stream, stream.output_stream);
        }

        /**
         * Instantiates a new DataStreamManager.
         *
         * When instantiating it from an output stream, the manager is
         * initialized with an empty game list. Save() is available, but not
         * Reset().
         *
         * @param stream The OutputStream to initialize from.
         */
        protected DataStreamManager.from_output_stream(OutputStream stream)
        {
            this.from_nullable_input_output_stream(null, stream);
        }

        /**
         * Instantiates a new DataStreamManager.
         *
         * Behaves like from_io_stream(), but takes the InputStream and the
         * OutputStream directly as separated arguments.
         *
         * @param input  The InputStream to initialize from.
         * @param output The OutputStream to initialize from.
         */
        protected DataStreamManager.from_input_output_stream(
            InputStream input, OutputStream output)
        {
            this.from_nullable_input_output_stream(input, output);
        }

        /**
         * Instantiates a new DataStreamManager.
         *
         * This constructor is intended to used inside this class, since it
         * accepts nullable types that are disabled in all other constructors.
         *
         * @param input  The InputStream to initialize from.
         * @param output The OutputStream to initialize from.
         */
        private DataStreamManager.from_nullable_input_output_stream(
            InputStream? input, OutputStream? output)
        {
            m_InputStream = input;
            m_OutputStream = output;
        }

        /**
         * Registers an InputStream to read from.
         *
         * @param stream The new InputStream to register.
         */
        public void RegisterInputStream(InputStream stream)
        {
            // If a previous stream was registered it will automatically be
            // closed if no other owns it, since it gets destructed then.
            m_InputStream = stream;
        }

        /**
         * Registers an OutputStream to write to.
         *
         * @param stream The new OutputStream to register.
         */
        public void RegisterOutputStream(OutputStream stream)
        {
            // If a previous stream was registered it will automatically be
            // closed if no other owns it, since it gets destructed then.
            m_OutputStream = stream;
        }

        /**
         * Registers an IOStream to read from and write to.
         *
         * @param stream The new IOStream to register.
         */
        public void RegisterIOStream(IOStream stream)
        {
            RegisterInputOutputStream(
                stream.input_stream, stream.output_stream);
        }

        /**
         * Registers an both, InputStream and OutputStream.
         *
         * @param input  The new InputStream to register.
         * @param output The new OutputStream to register.
         */
        public void RegisterInputOutputStream(InputStream input,
                                              OutputStream output)
        {
            RegisterInputStream(input);
            RegisterOutputStream(output);
        }

        /**
         * Releases the registered InputStream.
         *
         * If no InputStream was registered before, this function does nothing.
         */
        public void ReleaseInputStream()
        {
            // The streams auto-close if they are destructed.
            m_InputStream = null;
        }

        /**
         * Releases the registered OutputStream.
         *
         * If no OutputStream was registered before, this function does nothing.
         */
        public void ReleaseOutputStream()
        {
            // The streams auto-close if they are destructed.
            m_OutputStream = null;
        }

        /**
         * Releases all registered streams.
         */
        public void ReleaseStreams()
        {
            ReleaseInputStream();
            ReleaseOutputStream();
        }

        /**
         * Reinitializes the game list with the data from the registered
         * InputStream (so CanRead() returns true). If no InputStream was
         * registered, this function throws an exception.
         *
         * @throws IOError Thrown when no InputStream was registered.
         */
        public void Reset() throws IOError
        {
            ThrowIfCantRead();
            Parse(m_InputStream);
        }

        /**
         * Saves the data in the class into the registered OutputStream.
         * If no OutputStream was registered, this function throws an exception.
         *
         * @throws IOError Thrown when no OutputStream was registered.
         */
        public void Save() throws IOError
        {
            ThrowIfCantWrite();
            Write(m_OutputStream);
        }

        /**
         * Returns whether there can be read from the registered InputStream.
         */
        public bool CanRead
        {
            get
            {
                if(m_InputStream != null)
                {
                    return !m_InputStream.is_closed();
                }
                return false;
            }
        }

        /**
         * Returns whether there can be written to the registered OutputStream.
         */
        public bool CanWrite
        {
            get
            {
                if(m_OutputStream != null)
                {
                    return !m_OutputStream.is_closed();
                }
                return false;
            }
        }

        /**
         * Parses the data from input stream.
         *
         * Override this function in inheriting classes.
         *
         * @param stream The InputStream where to parse from.
         */
        protected abstract void Parse(InputStream stream);

        /**
         * Writes the data stored in this class.
         *
         * Override thisi function in inheriting classes.
         *
         * @pararm stram The OutputStream where to write to.
         */
        protected abstract void Write(OutputStream stream);

        /**
         * Just throws an exception if reading is unavailable (CanRead() returns
         * false).
         */
        private void ThrowIfCantRead() throws IOError
        {
            if (!CanRead)
            {
                throw new IOError.NOT_INITIALIZED(
                    "No InputStream registered in game Manager. " +
                    "Can't read data.");
            }
        }

        /**
         * Just throws an exception if writing is unavailable (CanWrite()
         * returns false).
         */
        private void ThrowIfCantWrite() throws IOError
        {
            if (!CanWrite)
            {
                throw new IOError.NOT_INITIALIZED(
                    "No OutputStream registered in game Manager. " +
                    "Can't write data.");
            }
        }

        /**
         * The underlying registered InputStream.
         */
        private InputStream m_InputStream;
        /**
         * The underlying registered OutputStream.
         */
        private OutputStream m_OutputStream;
    }
}

