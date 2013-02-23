var services;

services = require('../quartz-event-services');

event = new services.Event();

event.setType('mouseMoved');
event.setLocation(0.0, 0.0);

event.post();
