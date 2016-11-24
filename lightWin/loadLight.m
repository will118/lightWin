#import "loadLight.h"

LoadLight *plugin;

@implementation LoadLight

+ (LoadLight*) sharedInstance
{
    static LoadLight* plugin = nil;
    
    if (plugin == nil)
        plugin = [[LoadLight alloc] init];
    
    return plugin;
}

+ (void)load {
    plugin = [LoadLight sharedInstance];
}

@end

// TODO: opening prefs causes issue.
ZKSwizzleInterface(_light_TTWindow, TTWindow, NSResponder);
@implementation _light_TTWindow

- (void)becomeKeyWindow {
    ZKOrig(void);
    NSWindow *win = (NSWindow *)self;
    [win setHasShadow:NO];
    [win setStyleMask:NSWindowStyleMaskBorderless | NSWindowStyleMaskResizable];
}
@end


ZKSwizzleInterface(_light_TTTabView, TTTabView, NSResponder);
@implementation _light_TTTabView

- (void)initTabFrame {
    ZKOrig(void);
    NSTabView *tabView = (NSTabView*)self;
    for (NSView *aView in [tabView subviews]) {
        if ([aView isKindOfClass:[NSSplitView class]]) {
            NSRect frame = [aView frame];
            NSRect newFrame = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 1);
            [aView setFrame:newFrame];
        }
    }
}

@end
