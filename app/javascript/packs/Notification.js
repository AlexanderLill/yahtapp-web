function Notification() {
    return {
        show: true,
        init: function() {
            setTimeout(this.hide.bind(this),2000)
            setTimeout(() => this.$el.remove(),2500)
        },
        hide: function() {
            this.show = false
        }
    }
}
window.Notification = Notification