namespace GameBox.UI.Background
{
    /**
     * The base class for custom animated window backgrounds.
     */
    public abstract class AnimatedBackground : Background
    {
        /**
         * Instantiates a new AnimatedBackground without target.
         */
        protected AnimatedBackground()
        {
            base();
        }

        /**
         * Instantiates a new AnimatedBackground from Gtk.Widget target.
         *
         * @param widget The Gtk.Widget to draw on.
         */
        protected AnimatedBackground.from_target(Gtk.Widget widget)
        {
            base.from_target(widget);
        }

        ~AnimatedBackground()
        {
            // Unregister tick callback.
            if (Target != null)
            {
                Target.remove_tick_callback(m_TickCallbackID);
            }
        }

        /**
         * Invoked when the animation drawing needs an update.
         *
         * This function shall only update values necessary for drawing the
         * animation, not invoke Draw() itself! This is done automatically when
         * a tick is triggered!
         *
         * @param clock The Gdk.FrameClock that provides timing information.
         */
        protected abstract void Update(Gdk.FrameClock clock);

        // Inherited documentation.
        protected override void OnTargetChanged(Gtk.Widget old_widget,
                                                Gtk.Widget new_widget)
        {
            base.OnTargetChanged(old_widget, new_widget);

            if (old_widget != null)
            {
                // Unregister old tick callback.
                old_widget.remove_tick_callback(m_TickCallbackID);
            }

            if (new_widget != null)
            {
                // Register for tick callback in Gtk main loop.
                m_TickCallbackID = new_widget.add_tick_callback(OnTick);
            }
        }

        /**
         * Invoked when Gtk triggers a tick.
         *
         * @param widget      The Gtk.Widget where the tick callback is
         *                    registered.
         * @param frame_clock The Gdk.FrameClock that provides timing
         *                    information.
         */
        private bool OnTick(Gtk.Widget widget, Gdk.FrameClock frame_clock)
        {
            // Update and draw.
            Update(frame_clock);
            Draw(Gdk.cairo_create(widget.get_window()));

            // FIXME If available change to Source.CONTINUE (seems not supported
            // in this Vala version).
            return true;
        }

        /**
         * The tick callback ID needed to remove the callback registration.
         */
        private uint m_TickCallbackID;
    }
}

