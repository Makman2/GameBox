namespace GameBox.Game
{
    /**
     * Manages a file system format for storing games (described via
     * GameBox.Game).
     *
     * ### ÜBERARBEITEN! #####################################
     *
     * This manager is intended to read from or write to a controlling XML file
     * that stores the information of all games. To import a XML file use
     * the from_file() constructor. This automatically opens the file for read
     * access as long as this Manager lives or Release() is called.
     * To link to a file after the manager is instantiated, use Open().
     */
    public class Manager
    {
        /**
         * Instantiates a new Manager.
         *
         * Creates a Manager with an empty game list and no stream links.
         * You can register input/output streams via the ... and ... functions.
         */
        public Manager()
        {
        }

        public Manager.from_file(string file)
        {
        
        }

        /**
         * Instantiates a new Manager.
         *
         * When instantiating it from an IO stream, the manager is
         * initialized with the data from the given InputStream.
         * Reset() is available, but Save() not.
         *
         * @param stream The InputStream to initialize from.
         */
        public Manager.from_input_stream(InputStream stream)
        {
        }

        /**
         * Instantiates a new Manager.
         *
         * When instantiating it from an IO stream, the manager is
         * initialized with the data from the InputStream of the given IOStream.
         * Save() and Reset() are both available.
         *
         * @param stream The IOStream to initialize from.
         */
        public Manager.from_io_stream(IOStream stream)
        {
        }

        /**
         * Instantiates a new Manager.
         *
         * When instantiating it from an output stream, the manager is
         * initialized with an empty game list. Save() is available, but not
         * Reset().
         *
         * @param stream The OutputStream to initialize from.
         */
        public Manager.from_output_stream(OutputStream stream)
        {
        }

        public void Release()
        {
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

            // Reset here from file...
        }

        public void Save()
        {
            ThrowIfCantWrite();

            // Save to file...
        }

        public bool CanRead();
        public bool CanWrite();
        
        private ThrowIfCantRead() throws IOError
        {
            if (!CanRead)
            {
                throw new IOError.NOT_INITIALIZED(
                    "No InputStream registered in game Manager. " +
                    "Can't read data.");
            }
        }
        
        private ThrowIfCantWrite() throws IOError
        {
            if (!CanWrite)
            {
                throw new IOError.NOT_INITIALIZED(
                    "No OutputStream registered in game Manager. " +
                    "Can't write data.");
            }
        }
        
        private InputStream m_InputStream;
        private OutputStream m_OutputStream;
    }
}

