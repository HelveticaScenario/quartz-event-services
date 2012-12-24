#include <node.h>
#include "event.h"

using namespace v8;

Event::Event() {};
Event::~Event() {};

void Event::Init(Handle<Object> target) {
  Local<FunctionTemplate> tpl = FunctionTemplate::New(New);

  tpl->SetClassName(String::NewSymbol("event"));
  tpl->InstanceTemplate()->SetInternalFieldCount(1);

  Persistent<Function> constructor = Persistent<Function>::New(tpl->GetFunction());

  target->Set(String::NewSymbol("event"), constructor);
}

Handle<Value> Event::New(const Arguments& args) {
  HandleScope scope;

  Event* event = new Event();

  event->Wrap(args.This());

  return args.This();
}
