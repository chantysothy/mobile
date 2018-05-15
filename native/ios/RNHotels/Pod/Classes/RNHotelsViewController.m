//
//  RNHotelsViewController.m
//  RNHotels
//
//  Created by Radek Pistelak on 07/02/2018.
//  Copyright © 2018 Kiwi.com. All rights reserved.
//

#import "RNHotelsViewController.h"
#import "RNHotelsParameters.h"

#import <RNNavigator/RNNavigationModule.h>
#import <RNLogging/RNLoggingModule.h>
#import <RNTranslationManager/RNTranslationManager.h>
#import <RNCurrencyManager/RNCurrencyManager.h>
#import <RNColors/RNColors.h>
#import <RNDeviceInfo/RNDeviceInfo.h>

#import <React/RCTRootView.h>

@interface RNHotelsViewController() <RNNavigationDelegate, RNLogger, RNTranslator, RNCurrencyFormatter>

@property (nonatomic, strong) RNHotelsParameters *params;
@property (nonatomic, strong) RCTBridge *bridge;

@end

@implementation RNHotelsViewController

#pragma mark - Setup

- (instancetype)initWithBridge:(RCTBridge *)bridge params:(RNHotelsParameters *)params {
    self = [super init];
    if (self) {
        _bridge = bridge;
        _params = params;
        [self setupReactWrappersWithObject:self];
    }

    return self;
}

- (void)setupReactWrappersWithObject:(id)object {
    [RNLoggingModule setLogger:object];
    [RNNavigationModule setNavigationDelegate:object];
    [RNTranslationManager setTranslator:object];
    [RNCurrencyManager setCurrencyFormatter:object];
}

#pragma mark - View lifecycle

- (void)loadView {
    self.view = [[RCTRootView alloc] initWithBridge:_bridge moduleName:_params.moduleName initialProperties:_params.initialProperties];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    if ([self isBeingDismissed] || [self isMovingFromParentViewController]) {
        [self notifyFinish];
        [self setupReactWrappersWithObject:nil];
    }
}

#pragma mark - Overriden methods

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark - RNNavigation

- (void)userWantsLeaveHotels {
    [self notifyFinish];
}

#pragma mark - RNLogger

- (void)ancillaryDisplayed:(NSString *)type {

    if ([self didDisplayAncillary]) {
        self.didDisplayAncillary(type);
    }
}

- (void)ancillaryPurchased:(NSString *)type {

    if ([self didPurchaseAncillary]) {
        self.didPurchaseAncillary(type);
    }
}

#pragma mark - RNTranslationManager

- (NSString *)translate:(NSString *)key {
    return [self.translationProvider localizedStringWithKey:key] ?: key;
}

#pragma mark - RNCurrencyManager

- (NSString *)formatAmount:(NSNumber *)amount toCurrency:(NSString *)currency {
    return [self.currencyFormatter formattedPrice:amount withCurrency:currency];
}

#pragma mark - Helpers

- (void)notifyFinish {

    if ([self.flowDelegate respondsToSelector:@selector(RNHotelsViewControllerDidFinish:)]) {
        [self.flowDelegate RNHotelsViewControllerDidFinish:self];
    }
}

@end
