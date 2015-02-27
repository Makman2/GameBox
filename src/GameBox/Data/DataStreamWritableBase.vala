namespace GameBox.Data
{
    /**
     * Manages a stream system to store and write data to a file or stream
     * with a specific format (i.e. an XML-file). This class exposes a flexible
     * output interface to manage data in an OutputStream.
     *
     * This manager is intended to write data to a file or stream that shall
     * store specific data in a specific format. So this class exposes some kind
     * of serialization feature.
     *
     * To write your own format to the given OutputStream, override Write() in
     * your derivated classes.
     *
     * Streams are kept alive until the manager is destructed or you call
     * manually the release function ReleaseOutputStream().
     */
    public abstract class DataStreamWritableBase : IDataStreamWritable
    {
        /**
         * Instantiates a new DataStreamWritableBase.
         *
         * Creates a DataStreamWritableBase without an output stream.
         *
         * You can register an output stream later via the
         * RegisterOutputStream() function.
         */
        protected DataStreamWritableBase()
        {
            this.from_nullable_output_stream(null);
        }

        /**
         * Instantiates a new DataStreamWritableBase.
         *
         * Creates a DataStreamWritableBase from file with write access (if
         * supported).
         *
         * @param path   The path to the file to initialize from.
         * @throws Error Thrown when opening the file on path failed.
         */
        protected DataStreamWritableBase.from_file(string path) throws Error
        {
            //TODO: Wait until GLib.File supports opening a file in write-only
            //      mode. Now it's kind of ugly workaround code.
            File file = File.new_for_path(path);
            var stream = file.open_readwrite();

            stream.input_stream.close();

            this.from_nullable_output_stream(stream.output_stream);
        }

        /**
         * Instantiates a new DataStreamWritableBase.
         *
         * @param stream The OutputStream to initialize from.
         */
        protected DataStreamWritableBase.from_output_stream(OutputStream stream)
        {
            this.from_nullable_output_stream(stream);
        }

        /**
         * Instantiates a new DataStreamWritableBase.
         *
         * Intended for class internal use only.
         *
         * @param stream The OutputStream to initialize from.
         */
        private DataStreamWritableBase.from_nullable_output_stream(
            OutputStream? stream)
        {
            RegisterNullableOutputStream(stream);
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
         * Writes the data stored in this class to the output stream.
         *
         * Override this function in inheriting classes.
         *
         * @param stream The OutputStream where to write to.
         */
        protected abstract void Write(OutputStream stream);

        /**
         * Just throws an exception if writing is unavailable
         *
         * @throws IOError Thrown when writing is not possible (CanWrite()
         *                 returns false).
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
         * The underlying registered OutputStream.
         */
        private OutputStream m_OutputStream;
    }
}

