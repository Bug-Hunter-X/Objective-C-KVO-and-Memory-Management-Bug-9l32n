To solve this issue, always remove observers in the dealloc method of the observer class. If you are observing multiple objects, you should maintain a strong reference to the object you're observing and remove yourself as an observer when the object is deallocated. 

```objectivec
@interface MyObserver : NSObject
@property (nonatomic, weak) MyClass *observedObject;
@end

@implementation MyObserver
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog (@"Observed change");
}

- (void)dealloc {
    if (self.observedObject) {
        [self.observedObject removeObserver:self forKeyPath:@"myString"];
    }
}
@end

int main() {
    MyClass *myObject = [[MyClass alloc] init];
    myObject.myString = @"Hello";

    MyObserver *observer = [[MyObserver alloc] init];
    observer.observedObject = myObject; // Keep a strong reference to myObject
    [myObject addObserver:observer forKeyPath:@"myString" options:NSKeyValueObservingOptionNew context:NULL];

    myObject.myString = @"World"; // KVO notification is sent
    myObject = nil; // myObject deallocated

    return 0;
}
```

This revised code ensures that the observer removes itself as an observer of `myObject` before `myObject` is deallocated, preventing crashes or undefined behavior.