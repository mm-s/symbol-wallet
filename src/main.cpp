
using namespace std;

struct hmi_t: symbol::cli::hmi {
    typedef symbol::cli::hmi b;
    hmi_t(int argc, char** argv, ostream& os): b(argc, argv, os) {}
    void setup_signals(bool) override;
};

hmi_t* hmi{nullptr};

void sig_handler(int s) {
    cout << "main: received signal " << s << endl;
    cout << "stopping ...\n";
    hmi->stop();
    signal(SIGINT,SIG_DFL);
    signal(SIGTERM,SIG_DFL);
    signal(SIGPIPE,SIG_DFL);
}

void hmi_t::setup_signals(bool on) {
    if (on) {
        signal(SIGINT,sig_handler);
        signal(SIGTERM,sig_handler);
        signal(SIGPIPE, SIG_IGN);
    }
    else {
        signal(SIGINT,SIG_DFL);
        signal(SIGTERM,SIG_DFL);
        signal(SIGPIPE,SIG_DFL);
    }
}

int main(int argc, char** argv) {
    hmi=new hmi_t(argc, argv, cout);
    ko r=hmi->run();
    if (r!=us::ok) {
        screen::lock_t lock(hmi->scr, false);
        lock.os << r << '\n';
    }
    log("end");
    if (hmi->p.daemon) {
        screen::lock_t lock(hmi->scr, false);
        lock.os << "main: exited " << (r==ok?"normally":r) << '\n';
    }
    delete hmi;
    hmi=nullptr;
    return r==ok?0:1;

}
