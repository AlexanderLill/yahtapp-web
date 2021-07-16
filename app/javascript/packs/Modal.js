function Modal() {
    return {
        open: false,
        hide() {
          this.open = false;
        },
        toggle() {
            this.open = !this.open;
        },
        close: {
            ['@click']() {
                this.toggle()
            },
        },
        overlay: {
            ['x-show']() {
                return this.open
            },
            ['@click']() {
                this.hide();
            },
            ["x-transition:enter"]: "ease-out duration-300",
            ["x-transition:enter-start"] : "opacity-0",
            ["x-transition:enter-end="] : "opacity-100",
            ["x-transition:leave="] : "ease-in duration-200",
            ["x-transition:leave-start="] : "opacity-100",
            ["x-transition:leave-end="] : "opacity-0"
        },
        container: {
            ['x-show']() {
                return this.open
            },
            ['@show-modal.window']($event) {
                this.$el.id === $event.detail ? this.toggle() : false
            },
            ['@close-modal.window']($event) {
                this.$el.id === $event.detail ? this.close() : false
            },
            ['@keydown.escape.window']() {
                this.close();
            }
        },
        modal: {
            ['x-show']() {
                return this.open
            },
            ["x-transition:enter"]: "ease-out duration-300",
            ["x-transition:enter-start"] : "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
            ["x-transition:enter-end="] : "opacity-100 translate-y-0 sm:scale-100",
            ["x-transition:leave="] : "ease-in duration-200",
            ["x-transition:leave-start="] : "opacity-100 translate-y-0 sm:scale-100",
            ["x-transition:leave-end="] : "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
        }
    }
}
window.Modal = Modal;