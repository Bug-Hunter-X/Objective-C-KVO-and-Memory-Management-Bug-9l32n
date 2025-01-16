In Objective-C, a tricky bug can arise from the interaction between KVO (Key-Value Observing) and memory management, specifically when an observed object is deallocated while observers are still registered.  This can lead to crashes or unexpected behavior.  Consider this scenario:

```objectivec
@interface MyClass : NSObject
@property (nonatomic, strong) NSString *myString;
@end

@implementation MyClass
- (void)dealloc {
    NSLog (@"MyClass deallocated");
}
@end

@interface MyObserver : NSObject
@end

@implementation MyObserver
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog (@"Observed change");
}
@end

int main() {
    MyClass *myObject = [[MyClass alloc] init];
    myObject.myString = @"Hello";

    MyObserver *observer = [[MyObserver alloc] init];
    [myObject addObserver:observer forKeyPath:@"myString" options:NSKeyValueObservingOptionNew context:NULL];

    myObject.myString = @"World"; // KVO notification is sent
    myObject = nil; // myObject deallocated

    // ... potential crash here or unexpected behavior in other parts of the application
    return 0;
}
```

The observer is still registered with `myObject` when `myObject` is deallocated.  If the observer tries to access `myObject` after deallocation, the app will crash.