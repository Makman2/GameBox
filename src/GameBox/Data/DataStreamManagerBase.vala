namespace GameBox.Data
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
     * Override the Write() and Read() methods in your derivatives to implement
     * a specific DataStreamManagerBase that handles your data format.
     *
     * Streams are kept alive until the manager is destructed or you call
     * manually the release functions ReleaseInputStream(),
     * ReleaseOutputStream() or ReleaseStreams().
     */
    public abstract class DataStreamManagerBase
        : IDataStreamReadable, IDataStreamWritable
    {
        /**
         * Instantiates a new DataStreamManagerBase.
         *
         * Creates a DataStreamManagerBase without any input/output streams.
         *
         * You can register input/output streams via the RegisterInputStream()
         * and RegisterOutputStream() functions.
         */
        protected DataStreamManagerBase()
        {
            this.from_nullable_input_output_stream(null, null);
        }

        /**
         * Instantiates a new DataStreamManagerBase.
         *
         * Creates a DataStreamManagerBase from file with read and write access
         * (if supported, if not all access-types are supported these feature
         * will be missing and not usable).
         *
         * @param path   The path to the file to initialize from.
         * @throws Error Thrown when opening the file on path failed.
         */
        protected DataStreamManagerBase.from_file(string path) throws Error
        {
            File file = File.new_for_path(path);
            var stream = file.open_readwrite();

            this.from_nullable_input_output_stream(
                stream.input_stream, stream.output_stream);
        }

        /**
         * Instantiates a new DataStreamManagerBase.
         *
         * Only Reset() is available but not Save() since no OutputStream is
         * registered.
         *
         * @param stream The InputStream to initialize from.
         */
        protected DataStreamManagerBase.from_input_stream(InputStream stream)
        {
            this.from_nullable_input_output_stream(stream, null);
        }

        /**
         * Instantiates a new DataStreamManagerBase.
         *
         * Save() and Reset() are both available when using this constructor.
         *
         * @param stream The IOStream to initialize from.
         */
        protected DataStreamManagerBase.from_io_stream(IOStream stream)
        {
            this.from_nullable_input_output_stream(
                stream.input_stream, stream.output_stream);
        }

        /**
         * Instantiates a new DataStreamManagerBase.
         *
         * Only Save() is available but not Reset() since no InpuStream is
         * registered.
         *
         * @param stream The OutputStream to initialize from.
         */
        protected DataStreamManagerBase.from_output_stream(OutputStream stream)
        {
            this.from_nullable_input_output_stream(null, stream);
        }

        /**
         * Instantiates a new DataStreamManagerBase.
         *
         * Behaves like from_io_stream(), but takes the InputStream and the
         * OutputStream directly as separated arguments.
         *
         * @param input  The InputStream to initialize from.
         * @param output The OutputStream to initialize from.
         */
        protected DataStreamManagerBase.from_input_output_stream(
            InputStream input, OutputStream output)
        {
            this.from_nullable_input_output_stream(input, output);
        }

        /**
         * Instantiates a new DataStreamManagerBase.
         *
         * This constructor is intended to used inside this class, since it
         * accepts nullable types that are disabled in all other constructors.
         *
         * @param input  The InputStream to initialize from.
         * @param output The OutputStream to initialize from.
         */
        private DataStreamManagerBase.from_nullable_input_output_stream(
            InputStream? input, OutputStream? output)
        {
            RegisterNullableInputStream(input);
            RegisterNullableOutputStream(output);
        }

        /**
         * Registers an InputStream to read from.
         *
         * @param stream The new InputStream to register. Replaces the old one.
         */
        public void RegisterInputStream(InputStream stream)
        {
            RegisterNullableInputStream(stream);
        }

        /**
         * Register an InputStream to read from.
         *
         * Intended for class internal use only since it supports nullable types
         * that were explicitly disabled in all public registration functions.
         *
         * @param stream The new InputStream to register. Replaces the old one.
         */
        private void RegisterNullableInputStream(InputStream? stream)
        {
            // If a previous stream was registered it will automatically be
            // closed if no other owns it, since it gets destructed then.
            m_InputStream = stream;
        }

        /**
         * Registers an OutputStream to write to.
         *
         * @param stream The new OutputStream to register. Replaces the old one.
         */
        public void RegisterOutputStream(OutputStream stream)
        {
            RegisterNullableOutputStream(stream);
        }

       /**
         * Registers an OutputStream to write to.
         *
         * Intended for class internal use only since it supports nullable types
         * that were explicitly disabled in all public registration functions.
         *
         * @param stream The new OutputStream to register. Replaces the old one.
         */
        private void RegisterNullableOutputStream(OutputStream? stream)
        {
            // If a previous stream was registered it will automatically be
            // closed if no other owns it, since it gets destructed then.
            m_OutputStream = stream;
        }

        /**
         * Registers an IOStream to read from and write to.
         *
         * @param stream The new IOStream to register. Replaces the old input
         *               and output streams.
         */
        public void RegisterIOStream(IOStream stream)
        {
            RegisterInputOutputStream(
                stream.input_stream, stream.output_stream);
        }

        /**
         * Registers both, InputStream and OutputStream.
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
         * Reinitializes the class data with the data from the registered
         * InputStream (so CanRead() returns true). If no InputStream was
         * registered, this function throws an exception.
         *
         * Use this function for first data initialization, since the
         * construction of this class doesn't automatically call Reset() (you
         * are responsible for calling it when you need to read/reset from the
         * set InputStream).
         *
         * This function implicitly calls Read() if reading is available.
         *
         * @throws IOError Thrown when no InputStream was registered.
         */
        public void Reset() throws IOError
        {
            ThrowIfCantRead();
            Read(m_InputStream);
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
         *
         * @returns true if reading is allowed, false if not.
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
         *
         * @returns true if writing is allowed, false if not.
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
        protected abstract void Read(InputStream stream);

        /**
         * Writes the data stored in this class to the output stream.
         *
         * Override this function in inheriting classes.
         *
         * @param stream The OutputStream where to write to.
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
                    "No InputStream registered. Can't read data.");
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
                    "No OutputStream registered. Can't write data.");
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

