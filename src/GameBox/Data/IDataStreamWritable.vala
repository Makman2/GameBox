namespace GameBox.Data
{
    /**
     * Interface for saving and writing data to an OutputStream. This interface
     * exposes a flexible output interface to managa data in streams.
     *
     * This interface is intended to be implemented into the
     * GameBox.Data.DataStreamWritableBase (supports only OutputStream) and
     * GameBox.Data.DataStreamManagerBase (supports InputStream and
     * OutputStream).
     */
    public interface IDataStreamWritable
    {
        /**
         * Shall register an OutputStream to write to.
         *
         * @param stream The new OutputStream to register.
         */
        public abstract void RegisterOutputStream(OutputStream stream);

        /**
         * Shall release the registered OutputStream.
         */
        public abstract void ReleaseOutputStream();

        /**
         * Shall write the data from derivated classes into the registered
         * output stream.
         *
         * @throws Error Any error that can occur during implementation (i.e.
         *               IOError).
         */
        public abstract void Save() throws Error;

        /**
         * Shall return whether there can be written to the registered
         * OutputStream.
         *
         * @returns true if writing is allowed, false if not.
         */
        public abstract bool CanWrite
        { get; }

        /**
         * Shall write the data from derivated classes into the OutputStream.
         *
         * Override this function in inheriting classes.
         *
         * @param stream The OutputStream where to write to.
         */
        protected abstract void Write(OutputStream stream);
    }
}

