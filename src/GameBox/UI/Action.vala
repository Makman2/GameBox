namespace GameBox.UI
{
    /**
     * Represents an available action for interacting with the UI.
     */
    public class Action
    {
        /**
         * Instantiates a new Action without image no action description.
         */
        public Action()
        {
            this.from_data("", (Gdk.Pixbuf)null);
        }
        
        /**
         * Instantiates a new Action.
         *
         * @param description The action description. Says what the action does
         *                    when triggered.
         * @param image       The action image icon. Symbolizes the button that
         *                    triggers an action.
         */
        public Action.from_data(string description, Gdk.Pixbuf image)
        {
            this.Description = description;
            this.Image = image;
        }

        /**
         * Instantiates a new Action.
         *
         * @param description The action description. Says what the action does
         *                    when triggered.
         * @param image       The resource path to the action image icon.
         *                    Symbolizes the button that triggers an action.
         * @throws Error      Raised when loading the image from resources
         *                    fails.
         */
        public Action.from_resource(string description, string image) throws
            Error
        {
            this.Description = description;
            this.Image = new Gdk.Pixbuf.from_resource(image);
        }

        /**
         * The action image that symbolizes the button that triggers this
         * action.
         */
        public Gdk.Pixbuf Image
        { get; set; }

        /**
         * The action description that says what this action does when
         * triggered.
         */
        public string Description
        { get; set; }
    }
}

