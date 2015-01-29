namespace GameBox.Data
{
    /**
     * Interface for reading and parsing data from an InputStream. This
     * interface exposes a flexible input interface to manage data from streams.
     *
     * This interface is intended to be implemented into the
     * GameBox.Data.DataStreamReadableBase (only InputStream) and
     * GameBox.Data.DataStreamManagerBase (InputStream and OutputStream).
     */
    public interface IDataStreamReadable
    {
        /**
         * Shall register an InputStream to read from.
         *
         * @param stream The new InputStream to register.
         */
        public abstract void RegisterInputStream(InputStream stream);

        /**
         * Shall release registered InputStream.
         */
        public abstract void ReleaseInputStream();

        /**
         * Shall reset the data from derivatives and override them with the
         * data from registered InputStream.
         *
         * @throws Error Any error that can occur during implementation (i.e.
         *         IOError).
         */
        public abstract void Reset() throws Error;

        /**
         * Shall return whether there can be read from the registered
         * InputStream.
         *
         * @returns true if reading is allowed, false if not.
         */
        public abstract bool CanRead
        { get; }

        /**
         * Shall parse the data from input stream.
         *
         * Override this function in inheriting classes.
         *
         * @param stream The InputStream where to parse from.
         */
        protected abstract void Read(InputStream stream);
    }
}

