namespace GameBox
{
    /**
     * A GameBox resource management object.
     *
     * This class is a singleton! Only one instance can exist! Also this class
     * must be explicitly initialized (via Initialize()), otherwise no unique
     * instance is created and property Instance returns null.
     */
    internal class Resources
    {
        static construct
        {
            m_Instance = null;
        }

        /**
         * The location of the resource file relative to the executable.
         */
        private static const string RESOURCE_FILE = "resources.gresource";
        /**
         * The maximum buffer length, for security and RAM-limitation purposes.
         * Limited to 16MB.
         */
        public static const size_t SECURITY_MAXBUFFER = 0x100000;

        /**
         * Creates a new GameBox resource object and imports the according
         * resource files.
         *
         * This constructor is private since this class implements the singleton
         * design pattern.
         *
         * @throws FileError Raised when the resource file is not found, it's
         *                   size can't be determined, it exceeds the memory
         *                   limit of the constant in SECURITY_MAXBUFFER or a
         *                   reading stream can't be opened.
         * @throws IOError   Raised when the inputted resource file doesn't have
         *                   the right format or is corrupted.
         */
        private Resources() throws FileError, IOError
        {
            File file = File.new_for_path(RESOURCE_FILE);

            // Check if file exists.
            if (!file.query_exists())
            {
                throw new FileError.NOENT(
                    "Resource file at " + RESOURCE_FILE + " not found.");
            }

            // Check if memory limit is not exceeded.
            size_t size;
            try
            {
            size = (size_t)file.query_info(FileAttribute.STANDARD_SIZE,
                FileQueryInfoFlags.NONE).get_size();
            }
            catch (Error ex)
            {
                throw new FileError.FAILED(
                    "Size of file can't be determined: " + ex.message);
            }

            if (size > SECURITY_MAXBUFFER)
            {
                throw new FileError.NOMEM(
                    "Resource file exceeds application defined memory limit " +
                    "of " + SECURITY_MAXBUFFER.to_string() + " bytes. File " +
                    "has " + size.to_string() + " bytes.");
            }

            // Create stream from file.
            FileInputStream stream;
            try
            {
                stream = file.read();
            }
            catch (Error ex)
            {
                throw new FileError.FAILED(
                    "Resource file-stream can't be opened for read access: " +
                    ex.message);
            }

            // Read entire file from stream.
            m_Data = new Bytes(new uint8[size]);
            stream.read(m_Data.get_data());

            // Feed the real resource constructor.
            try
            {
                m_Resource = new Resource.from_data(m_Data);
            }
            catch (Error ex)
            {
                throw new IOError.INVALID_DATA(
                    "Invalid resource file: " + ex.message);
            }

            // Register them to the GameBox process.
            resources_register(m_Resource);
        }

        ~Resources()
        {
            // Unregister resources from GameBox process.
            resources_unregister(m_Resource);
        }

        /**
         * Retrieves the instance of this singleton object.
         *
         * @returns The instance of type GameBox.Resources.
         */
        internal static Resources Instance
        {
            get
            {
                return m_Instance;
            }
        }

        /**
         * Manually initializes the singleton object.
         */
        internal static void Initialize() throws FileError, IOError
        {
            if (m_Instance == null)
            {
                m_Instance = new Resources();
                stdout.printf("Resources loaded (" + RESOURCE_FILE + ").\n");
            }
        }

        /**
         * Provides access to the underlying GLib resource object.
         *
         * @returns The underlying GLib resource object of this GameBox
         *          resource manager.
         */
        internal Resource Resource
        {
            get
            {
                return m_Resource;
            }
        }

        /**
         * Holds the instance of this singleton object.
         */
        private static Resources m_Instance;
        
        /**
         * Holds the underlying GLib resource object.
         */
        private Resource m_Resource;
        /**
         * The data-blob needed by the GLib resource object.
         */
        private Bytes m_Data;
    }
}

