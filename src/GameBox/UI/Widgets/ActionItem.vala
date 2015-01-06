namespace GameBox.UI.Widgets
{
    /**
     * Displays a list-item that presents an available action.
     */
    public class ActionItem : Gtk.Bin
    {
        /**
         * Instantiates a new empty ActionItem.
         */
        public ActionItem()
        {
            this.from_action(new GameBox.UI.Action());
        }

        /**
         * Instantiates an ActionItem from the given GameBox.UI.Action.
         *
         * @param action The GameBox.UI.Action to initialize with.
         */
        public ActionItem.from_action(GameBox.UI.Action action)
        {
            Object();

            InitializeComponent();
            InitializeReferences();

            this.Action = action;
        }

        /**
         * Initializes the widget layout.
         */
        private void InitializeComponent()
        {
            // Build layout from Gtk.Builder and resource Glade file.
            const string resource_name = "/GameBox/UI/Widgets/ActionItem.glade";
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
            m_ReferenceActionImage = (Gtk.Image)m_Builder.get_object("Image");
            m_ReferenceActionLabel =
                (Gtk.Label)m_Builder.get_object("Description");
        }

        /**
         * The associated GameBox.UI.Action description object that contains
         * the action information.
         */
        public GameBox.UI.Action Action
        {
            get
            {
                return m_Action;
            }
            set
            {
                m_Action = value;
                m_ReferenceActionImage.set_from_pixbuf(value.Image);
                m_ReferenceActionLabel.label = value.Description;
            }
        }

        /**
         * The layout builder.
         */
        private Gtk.Builder m_Builder;
        /**
         * Reference to the action Gtk.Image.
         */
        private Gtk.Image m_ReferenceActionImage;
        /**
         * Reference to the action description Gtk.Label.
         */
        private Gtk.Label m_ReferenceActionLabel;

        /**
         * The associated action.
         */
        private GameBox.UI.Action m_Action;
    }
}

