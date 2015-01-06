namespace GameBox.UI
{
    public class ApplicationWindow : Gtk.ApplicationWindow
    {
        /**
         * Instantiates a new GameBox application window.
         */
        public ApplicationWindow(Gtk.Application application)
        {
            Object(application: application);

            InitializeComponents();
            InitializeReferences();

            // Initialize fields.
            this.set_default_size(400, 400);
            this.title = "GameBox";

            // ### EXAMPLE TEST CODE!!! ###
            //  ~~~ ADD ACTION
            GameBox.UI.Action action;
            action = new GameBox.UI.Action.from_resource(
               "Play", "/GameBox/UI/ActionPS3X.png");
            GameBox.UI.Widgets.ActionItem actionitem =
                new GameBox.UI.Widgets.ActionItem.from_action(action);
            m_ActionList.add(actionitem);
            //  ~~~ ADD TWO GAMES
            GameBox.Game.Game fzero = new GameBox.Game.Game.from_resource(
                "F-Zero", "SNES", "The most popular racing game on SNES!",
                "Racing", "/GameBox/f-zero.jpg");
            GameBox.Game.Game castlevania = new GameBox.Game.Game.from_resource(
                "Super Castlevania 4", "SNES", "Fight through several levels" +
                " filled with monsters in the fourth part of the Castlevania" +
                " saga!", "Jump'n'Run", "/GameBox/super-castlevania-4.jpg");
            
            GameBox.UI.Widgets.GameItem item1 =
                new GameBox.UI.Widgets.GameItem.from_game(fzero);
            GameBox.UI.Widgets.GameItem item2 =
                new GameBox.UI.Widgets.GameItem.from_game(castlevania);

            m_GameList.add(item1);
            m_GameList.add(item2);
            
            // ### TEST: START SNES9X EMULATOR ###
            // ### PLUG/SOCKET MECHANISM NEEDS TO BE IMPLEMENTED INSIDE
            //     SNES9X. Need to create a plug and a pipe to pass the plug-id
            //     over it. ###
            
            /*            
            string[] procargs = {"../emulators/snes9x/unix/snes9x",
                                 "../emulators/Super Castlevania IV.smc"};
            SubprocessLauncher launcher =
                new SubprocessLauncher(SubprocessFlags.NONE);
            Subprocess proc = launcher.spawnv(procargs);
            */
        }

        /**
         * Initializes the graphical components of the widget.
         */
        private void InitializeComponents()
        {
            // Get design file directly from registered resources.
            const string resource_id = "/GameBox/UI/GameMenuWindow.glade";
            m_Builder = new Gtk.Builder.from_resource(resource_id);

            // Define the toplevel-object ID that is added from the builder.
            const string toplevel = "Toplevel";
            this.add((Gtk.Widget)m_Builder.get_object(toplevel));
        }

        /**
         * Initializes needed references from the GTK builder object.
         */
        private void InitializeReferences()
        {
            m_GameList = (Gtk.ListBox)m_Builder.get_object("GameList");
            m_ActionList = (Gtk.Box)m_Builder.get_object("ActionList");
        }

        private Gtk.Builder m_Builder;
        private Gtk.ListBox m_GameList;
        private Gtk.Box m_ActionList;
    }
}

