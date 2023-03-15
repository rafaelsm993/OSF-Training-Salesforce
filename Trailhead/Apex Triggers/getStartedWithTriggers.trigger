trigger getStartedWithTriggers on Account (before insert) {
    System.debug('Hello World!');
}