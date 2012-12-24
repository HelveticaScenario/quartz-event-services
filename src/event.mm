#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

#include <node.h>
#include <string>
#include "event.h"

using namespace v8;

Event::Event() {};
Event::~Event() {};

void Event::Init(Handle<Object> target) {
  Local<FunctionTemplate> tpl = FunctionTemplate::New(New);

  tpl->SetClassName(String::NewSymbol("event"));
  tpl->InstanceTemplate()->SetInternalFieldCount(1);
  tpl->PrototypeTemplate()->Set(String::NewSymbol("post"),
      FunctionTemplate::New(Post)->GetFunction());
  tpl->PrototypeTemplate()->Set(String::NewSymbol("setType"),
      FunctionTemplate::New(SetType)->GetFunction());

  Persistent<Function> constructor = Persistent<Function>::New(tpl->GetFunction());

  target->Set(String::NewSymbol("event"), constructor);
}

Handle<Value> Event::New(const Arguments& args) {
  HandleScope scope;

  Event* event = new Event();
  event->raw_ = CGEventCreate(NULL);

  event->Wrap(args.This());

  return args.This();
}

CGEventType Event::TypeFromString(std::string str) {
  if (str == "leftMouseDown")
    return kCGEventLeftMouseDown;

  if (str == "leftMouseUp")
    return kCGEventLeftMouseUp;

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

Handle<Value> Event::Post(const Arguments& args) {
  HandleScope scope;

  Event* event = ObjectWrap::Unwrap<Event>(args.This());
  CGPoint point = CGEventGetLocation(event->raw_);

  CGEventSetLocation(event->raw_, point);
  CGEventPost(kCGHIDEventTap, event->raw_);

  NSLog(@"Location? x= %f, y = %f", (float)point.x, (float)point.y);

  CFRelease(event->raw_);

  return scope.Close(Undefined());
}
