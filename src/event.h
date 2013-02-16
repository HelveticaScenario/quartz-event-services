#import <ApplicationServices/ApplicationServices.h>

#include <node.h>
#include <string>

class Event : public node::ObjectWrap {
  public:
    static void Init(v8::Handle<v8::Object> target);

  private:
    Event();
    ~Event();

    static v8::Handle<v8::Value> New(const v8::Arguments& args);
    static v8::Handle<v8::Value> Post(const v8::Arguments& args);
    static v8::Handle<v8::Value> SetType(const v8::Arguments& args);
    static v8::Handle<v8::Value> SetIntegerValueField(const v8::Arguments& args);
    static v8::Handle<v8::Value> SetLocation(const v8::Arguments& args);
    static v8::Handle<v8::Value> GetLocation(const v8::Arguments& args);
    static CGEventType TypeFromString(std::string str);
    static CGEventType ValueFieldFromString(std::string str);

    CGEventRef raw_;
    CGEventSourceRef source_;
};
