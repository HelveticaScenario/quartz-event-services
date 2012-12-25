#include <node.h>
#include "event.h"

using namespace v8;

void InitAll(Handle<Object> target) {
  Event::Init(target);
}

NODE_MODULE(quartz_event_services, InitAll)
