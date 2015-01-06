namespace GameBox.UI.Widgets
{
    /**
     * Displays a list-item that presents a playable game.
     */
    public class GameItem : Gtk.Bin
    {
        /**
         * Instantiates a new empty GameItem.
         */
        public GameItem()
        {
            this.from_game(new GameBox.Game.Game());
        }

        /**
         * Instantiates a GameItem from the given GameBox.Game.Game.
         *
         * @param game The GameBox.Game.Game to initialize with.
         */
        public GameItem.from_game(GameBox.Game.Game game)
        {
            this.from_data(game, 360, 180);
        }

        /**
         * Instantiates a GameItem from the given GameBox.Game.Game and image
         * scalings.
         *
         * @param game         The GameBox.Game.Game to initialize with.
         * @param scale_width  The image scale width.
         * @param scale_height The image scale height.
         */
        public GameItem.from_data(GameBox.Game.Game game,
                                  int               scale_width,
                                  int               scale_height)
        {
            Object();

            InitializeComponent();
            InitializeReferences();

            this.m_ScaleWidth = scale_width;
            this.m_ScaleHeight = scale_height;
            this.Game = game;
        }

        /**
         * Initializes the widget layout.
         */
        private void InitializeComponent()
        {
            // Build layout from Gtk.Builder and resource Glade file.
            const string resource_name = "/GameBox/UI/Widgets/GameItem.glade";
            m_Builder = new Gtk.Builder.from_resource(resource_name);

            // The ID of the toplevel object to load from the Glade UI file.
            const string toplevel = "Toplevel";
            this.add((Gtk.Widget)m_Builder.get_object(toplevel));
        }

        /**
         * Initializes all needed widget references of the layout.
         */
        private void InitializeReferences()
        {
            m_ReferenceImage = (Gtk.Image)m_Builder.get_object("Cover");
            m_ReferenceTitle = (Gtk.Label)m_Builder.get_object("Title");
            m_ReferencePlatform = (Gtk.Label)m_Builder.get_object("Platform");
            m_ReferenceDescription =
                (Gtk.Label)m_Builder.get_object("Description");
        }

        /**
         * The associated GameBox.Game.Game description object that contains
         * the game information.
         */
        public GameBox.Game.Game Game
        {
            get
            {
                return m_Game;
            }
            set
            {
                m_Game = value;
                m_ReferenceImage.set_from_pixbuf(value.Image.scale_simple(
                    this.ScaleWidth, this.ScaleHeight,
                    Gdk.InterpType.BILINEAR));
                m_ReferenceTitle.label = value.Title;
                m_ReferencePlatform.label = value.Platform;
                m_ReferenceDescription.label = value.Description;
            }
        }

        /**
         * The scale width of the image.
         */
        public int ScaleWidth
        {
            get
            {
                return m_ScaleWidth;
            }
            set
            {
                m_ScaleWidth = value;
                m_ReferenceImage.set_from_pixbuf(this.Game.Image.scale_simple(
                    value, this.ScaleHeight, Gdk.InterpType.BILINEAR));
            }
        }

        /**
         * The scale height of the image.
         */
        public int ScaleHeight
        {
            get
            {
                return m_ScaleHeight;
            }
            set
            {
                m_ScaleHeight = value;
                m_ReferenceImage.set_from_pixbuf(this.Game.Image.scale_simple(
                    this.ScaleWidth, value, Gdk.InterpType.BILINEAR));
            }
        }

        /**
         * The layout builder.
         */
        private Gtk.Builder m_Builder;
        /**
         * Reference to the game cover Gtk.Image.
         */
        private Gtk.Image m_ReferenceImage;
        /**
         * Reference to the game title Gtk.Label.
         */
        private Gtk.Label m_ReferenceTitle;
        /**
         * Reference to the game platform Gtk.Label.
         */
        private Gtk.Label m_ReferencePlatform;
        /**
         * Reference to the game description Gtk.Label.
         */
        private Gtk.Label m_ReferenceDescription;

        /**
         * The associated game.
         */
        private GameBox.Game.Game m_Game;

        /**
         * The image scale width.
         */
        private int m_ScaleWidth;

        /**
         * The image scale height.
         */
        private int m_ScaleHeight;
    }
}

