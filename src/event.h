#include <node.h>

class Event : public node::ObjectWrap {
  public:
    static void Init(v8::Handle<v8::Object> target);

  private:
    Event();
    ~Event();

    static v8::Handle<v8::Value> New(const v8::Arguments& args);
};
