#import <ApplicationServices/ApplicationServices.h>

#include <node.h>
#include <string>
#include "event.h"

using namespace v8;

Event::Event() {};
Event::~Event() {};

void Event::Init(Handle<Object> target) {
  Local<FunctionTemplate> tpl = FunctionTemplate::New(New);

  tpl->SetClassName(String::NewSymbol("Event"));
  tpl->InstanceTemplate()->SetInternalFieldCount(1);
  tpl->PrototypeTemplate()->Set(String::NewSymbol("post"),
      FunctionTemplate::New(Post)->GetFunction());
  tpl->PrototypeTemplate()->Set(String::NewSymbol("setType"),
      FunctionTemplate::New(SetType)->GetFunction());
  tpl->PrototypeTemplate()->Set(String::NewSymbol("setIntegerValueField"),
      FunctionTemplate::New(SetIntegerValueField)->GetFunction());
  tpl->PrototypeTemplate()->Set(String::NewSymbol("setLocation"),
      FunctionTemplate::New(SetLocation)->GetFunction());
  tpl->PrototypeTemplate()->Set(String::NewSymbol("getLocation"),
      FunctionTemplate::New(GetLocation)->GetFunction());

  Persistent<Function> constructor = Persistent<Function>::New(tpl->GetFunction());

  target->Set(String::NewSymbol("Event"), constructor);
}

Handle<Value> Event::New(const Arguments& args) {
  HandleScope scope;

  Event* event = new Event();
  event->source_ = CGEventSourceCreate(kCGEventSourceStatePrivate);
  event->raw_ = CGEventCreate(event->source_);

  event->Wrap(args.This());

  return args.This();
}

CGEventType Event::TypeFromString(std::string str) {
  if (str == "leftMouseDown")
    return kCGEventLeftMouseDown;

  if (str == "leftMouseUp")
    return kCGEventLeftMouseUp;

  if (str == "mouseMoved")
    return kCGEventMouseMoved;

  return NULL;
}

CGEventType Event::ValueFieldFromString(std::string str) {
  if (str == "mouseEventClickState")
    return kCGMouseEventClickState;

  return NULL;
}

Handle<Value> Event::SetType(const Arguments& args) {
  HandleScope scope;

  v8::String::Utf8Value theString(args[0]->ToString());

  Event* event = ObjectWrap::Unwrap<Event>(args.This());
  CGEventType type = Event::TypeFromString(*theString);

  CGEventSetType(event->raw_, type);

  return scope.Close(Undefined());
}

Handle<Value> Event::SetIntegerValueField(const Arguments& args) {
  HandleScope scope;

  v8::String::Utf8Value theString(args[0]->ToString());

  Event* event = ObjectWrap::Unwrap<Event>(args.This());
  CGEventField field = Event::TypeFromString(*theString);

  CGEventSetIntegerValueField(event->raw_, field, args[1]->NumberValue());

  return scope.Close(Undefined());
}

Handle<Value> Event::SetLocation(const Arguments& args) {
  HandleScope scope;

  Event* event = ObjectWrap::Unwrap<Event>(args.This());
  CGPoint point = CGPointMake(args[0]->NumberValue(), args[1]->NumberValue());

  CGEventSetLocation(event->raw_, point);

  return scope.Close(Undefined());
}

Handle<Value> Event::GetLocation(const Arguments& args) {
  HandleScope scope;

  Event* event = ObjectWrap::Unwrap<Event>(args.This());
  CGPoint point = CGEventGetLocation(event->raw_);
  Local<Object> coordinates = Object::New();
  Local<Number> x = Number::New(point.x);
  Local<Number> y = Number::New(point.y);

  coordinates->Set(String::NewSymbol("x"), x);
  coordinates->Set(String::NewSymbol("y"), y);

  return scope.Close(coordinates);
}

Handle<Value> Event::Post(const Arguments& args) {
  HandleScope scope;

  Event* event = ObjectWrap::Unwrap<Event>(args.This());

  CGEventPost(kCGHIDEventTap, event->raw_);
  CFRelease(event->raw_);

  return scope.Close(Undefined());
}
