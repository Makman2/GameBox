namespace GameBox.Data
{
    /**
     * Manages a stream system to read and parse data from an InputStream. This
     * class exposes a flexible input interface to manage data from InputStream.
     *
     * This manager is intended to read from a file or stream that stores
     * specific data (i.e. an XML-file) that will be parsed in this class
     * (inside Read()). After the parsing process derivative classes expose
     * members to access the data.
     *
     * To parse your own data from the given InputStream, override Read() in
     * your derivative class.
     *
     * Streams are kept alive until the manager is destructed or you call
     * manually the release function ReleaseInputStream().
     */
    public abstract class DataStreamReadableBase
        : IDataStreamReadable
    {
        /**
         * Instantiates a new DataStreamReadableBase.
         *
         * Creates a DataStreamReadableBase without any underlying input
         * streams.
         *
         * You can register an input streams via the RegisterInputStream()
         * function.
         */
        protected DataStreamReadableBase()
        {
            this.from_nullable_input_stream(null);
        }

        /**
         * Instantiates a new DataStreamReadableBase.
         *
         * Creates a DataStreamReadableBase from file with read access (if
         * supported).
         *
         * @param path   The path to the file to initialize from.
         * @throws Error Thrown when opening the file on path failed.
         */
        protected DataStreamReadableBase.from_file(string path) throws Error
        {
            //TODO: Wait until GLib.File supports opening a file in readonly
            //      mode. Now it's kind of ugly workaround code.
            File file = File.new_for_path(path);
            var stream = file.open_readwrite();

            stream.output_stream.close();

            this.from_nullable_input_stream(stream.input_stream);
            
        }

        /**
         * Instantiates a new DataStreamReadableBase.
         *
         * @param stream The InputStream to initialize with.
         */
        protected DataStreamReadableBase.from_input_stream(InputStream stream)
        {
            this.from_nullable_input_stream(stream);
        }

        /**
         * Instantiates a new DataStreamReadableBase.
         *
         * Intended for class internal use only.
         *
         * @param stream The InputStream to initialize with.
         */
        private DataStreamReadableBase.from_nullable_input_stream(
            InputStream? stream)
        {
            RegisterNullableInputStream(stream);
        }

        /**
         * Registers an InputStream to read from.
         *
         * @param stream The new InputStream to register.
         */
        public void RegisterInputStream(InputStream stream)
        {
            RegisterNullableInputStream(stream);
        }

        private void RegisterNullableInputStream(InputStream? stream)
        {
            // If a previous stream was registered it will automatically be
            // closed if no other owns it, since it gets destructed then.
            m_InputStream = stream;
        }

        /**
         * Releases the registered InputStream.
         *
         * If no InputStream was registered before, this function does nothing.
         */
        public void ReleaseInputStream()
        {
            // The stream auto-closes if it's destructed.
            m_InputStream = null;
        }

        /**
         * Parses the data from registered input stream.
         *
         * Override this function in inheriting classes.
         *
         * @param stream The InputStream where to parse from.
         */
        protected abstract void Read(InputStream stream);

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
         * The underlying registered InputStream.
         */
        private InputStream m_InputStream;
    }
}

