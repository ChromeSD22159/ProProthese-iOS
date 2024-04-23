// Generated by Apple Swift version 5.9 (swiftlang-5.9.0.128.108 clang-1500.0.40.1)
#ifndef PROWATCHOS_WATCH_APP_SWIFT_H
#define PROWATCHOS_WATCH_APP_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#if defined(__OBJC__)
#include <Foundation/Foundation.h>
#endif
#if defined(__cplusplus)
#include <cstdint>
#include <cstddef>
#include <cstdbool>
#include <cstring>
#include <stdlib.h>
#include <new>
#include <type_traits>
#else
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <string.h>
#endif
#if defined(__cplusplus)
#if defined(__arm64e__) && __has_include(<ptrauth.h>)
# include <ptrauth.h>
#else
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreserved-macro-identifier"
# ifndef __ptrauth_swift_value_witness_function_pointer
#  define __ptrauth_swift_value_witness_function_pointer(x)
# endif
# ifndef __ptrauth_swift_class_method_pointer
#  define __ptrauth_swift_class_method_pointer(x)
# endif
#pragma clang diagnostic pop
#endif
#endif

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...) 
# endif
#endif
#if !defined(SWIFT_RUNTIME_NAME)
# if __has_attribute(objc_runtime_name)
#  define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
# else
#  define SWIFT_RUNTIME_NAME(X) 
# endif
#endif
#if !defined(SWIFT_COMPILE_NAME)
# if __has_attribute(swift_name)
#  define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
# else
#  define SWIFT_COMPILE_NAME(X) 
# endif
#endif
#if !defined(SWIFT_METHOD_FAMILY)
# if __has_attribute(objc_method_family)
#  define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
# else
#  define SWIFT_METHOD_FAMILY(X) 
# endif
#endif
#if !defined(SWIFT_NOESCAPE)
# if __has_attribute(noescape)
#  define SWIFT_NOESCAPE __attribute__((noescape))
# else
#  define SWIFT_NOESCAPE 
# endif
#endif
#if !defined(SWIFT_RELEASES_ARGUMENT)
# if __has_attribute(ns_consumed)
#  define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
# else
#  define SWIFT_RELEASES_ARGUMENT 
# endif
#endif
#if !defined(SWIFT_WARN_UNUSED_RESULT)
# if __has_attribute(warn_unused_result)
#  define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
# else
#  define SWIFT_WARN_UNUSED_RESULT 
# endif
#endif
#if !defined(SWIFT_NORETURN)
# if __has_attribute(noreturn)
#  define SWIFT_NORETURN __attribute__((noreturn))
# else
#  define SWIFT_NORETURN 
# endif
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA 
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA 
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA 
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif
#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif
#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER 
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility) 
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED_OBJC)
# if __has_feature(attribute_diagnose_if_objc)
#  define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
# else
#  define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
# endif
#endif
#if defined(__OBJC__)
#if !defined(IBSegueAction)
# define IBSegueAction 
#endif
#endif
#if !defined(SWIFT_EXTERN)
# if defined(__cplusplus)
#  define SWIFT_EXTERN extern "C"
# else
#  define SWIFT_EXTERN extern
# endif
#endif
#if !defined(SWIFT_CALL)
# define SWIFT_CALL __attribute__((swiftcall))
#endif
#if !defined(SWIFT_INDIRECT_RESULT)
# define SWIFT_INDIRECT_RESULT __attribute__((swift_indirect_result))
#endif
#if !defined(SWIFT_CONTEXT)
# define SWIFT_CONTEXT __attribute__((swift_context))
#endif
#if !defined(SWIFT_ERROR_RESULT)
# define SWIFT_ERROR_RESULT __attribute__((swift_error_result))
#endif
#if defined(__cplusplus)
# define SWIFT_NOEXCEPT noexcept
#else
# define SWIFT_NOEXCEPT 
#endif
#if !defined(SWIFT_C_INLINE_THUNK)
# if __has_attribute(always_inline)
# if __has_attribute(nodebug)
#  define SWIFT_C_INLINE_THUNK inline __attribute__((always_inline)) __attribute__((nodebug))
# else
#  define SWIFT_C_INLINE_THUNK inline __attribute__((always_inline))
# endif
# else
#  define SWIFT_C_INLINE_THUNK inline
# endif
#endif
#if defined(_WIN32)
#if !defined(SWIFT_IMPORT_STDLIB_SYMBOL)
# define SWIFT_IMPORT_STDLIB_SYMBOL __declspec(dllimport)
#endif
#else
#if !defined(SWIFT_IMPORT_STDLIB_SYMBOL)
# define SWIFT_IMPORT_STDLIB_SYMBOL 
#endif
#endif
#if defined(__OBJC__)
#if __has_feature(objc_modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import CoreData;
@import CoreLocation;
@import Foundation;
@import HealthKit;
@import Intents;
@import ObjectiveC;
@import WatchConnectivity;
@import WatchKit;
#endif

#endif
#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"
#pragma clang diagnostic ignored "-Wdollar-in-identifier-extension"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="ProWatchOS_Watch_App",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

#if defined(__OBJC__)
@class NSEntityDescription;
@class NSManagedObjectContext;

SWIFT_CLASS_NAMED("BackgroundTaskItem")
@interface BackgroundTaskItem : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@class NSString;
@class NSDate;

@interface BackgroundTaskItem (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSString * _Nullable action;
@property (nonatomic, copy) NSString * _Nullable data;
@property (nonatomic, copy) NSDate * _Nullable date;
@property (nonatomic, copy) NSString * _Nullable task;
@end


SWIFT_CLASS_NAMED("Contact")
@interface Contact : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@class Event;
@class NSSet;

@interface Contact (SWIFT_EXTENSION(ProWatchOS_Watch_App))
- (void)addEventsObject:(Event * _Nonnull)value;
- (void)removeEventsObject:(Event * _Nonnull)value;
- (void)addEvents:(NSSet * _Nonnull)values;
- (void)removeEvents:(NSSet * _Nonnull)values;
@end

@class RecurringEvents;

@interface Contact (SWIFT_EXTENSION(ProWatchOS_Watch_App))
- (void)addRecurringEventsObject:(RecurringEvents * _Nonnull)value;
- (void)removeRecurringEventsObject:(RecurringEvents * _Nonnull)value;
- (void)addRecurringEvents:(NSSet * _Nonnull)values;
- (void)removeRecurringEvents:(NSSet * _Nonnull)values;
@end

@class ContactPerson;

@interface Contact (SWIFT_EXTENSION(ProWatchOS_Watch_App))
- (void)addContactPersonsObject:(ContactPerson * _Nonnull)value;
- (void)removeContactPersonsObject:(ContactPerson * _Nonnull)value;
- (void)addContactPersons:(NSSet * _Nonnull)values;
- (void)removeContactPersons:(NSSet * _Nonnull)values;
@end


@interface Contact (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSString * _Nullable icon;
@property (nonatomic, copy) NSString * _Nullable mail;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable phone;
@property (nonatomic, copy) NSString * _Nullable titel;
@property (nonatomic, strong) NSSet * _Nullable contactPersons;
@property (nonatomic, strong) NSSet * _Nullable events;
@property (nonatomic, strong) NSSet * _Nullable recurringEvents;
@end


SWIFT_CLASS_NAMED("ContactPerson")
@interface ContactPerson : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



@interface ContactPerson (SWIFT_EXTENSION(ProWatchOS_Watch_App))
- (void)addEventObject:(Event * _Nonnull)value;
- (void)removeEventObject:(Event * _Nonnull)value;
- (void)addEvent:(NSSet * _Nonnull)values;
- (void)removeEvent:(NSSet * _Nonnull)values;
@end


@interface ContactPerson (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSString * _Nullable firstname;
@property (nonatomic, copy) NSString * _Nullable lastname;
@property (nonatomic, copy) NSString * _Nullable mail;
@property (nonatomic, copy) NSString * _Nullable mobil;
@property (nonatomic, copy) NSString * _Nullable phone;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, strong) Contact * _Nullable contact;
@property (nonatomic, strong) NSSet * _Nullable event;
@end


SWIFT_CLASS_NAMED("Event")
@interface Event : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@class EventTasks;

@interface Event (SWIFT_EXTENSION(ProWatchOS_Watch_App))
- (void)addTasksObject:(EventTasks * _Nonnull)value;
- (void)removeTasksObject:(EventTasks * _Nonnull)value;
- (void)addTasks:(NSSet * _Nonnull)values;
- (void)removeTasks:(NSSet * _Nonnull)values;
@end


@interface Event (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSDate * _Nullable endDate;
@property (nonatomic, copy) NSString * _Nullable eventID;
@property (nonatomic, copy) NSString * _Nullable icon;
@property (nonatomic, copy) NSDate * _Nullable startDate;
@property (nonatomic, copy) NSString * _Nullable titel;
@property (nonatomic, strong) Contact * _Nullable contact;
@property (nonatomic, strong) ContactPerson * _Nullable contactPerson;
@property (nonatomic, strong) NSSet * _Nullable tasks;
@end


SWIFT_CLASS_NAMED("EventTasks")
@interface EventTasks : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



@interface EventTasks (SWIFT_EXTENSION(ProWatchOS_Watch_App))
- (void)addEventsObject:(Event * _Nonnull)value;
- (void)removeEventsObject:(Event * _Nonnull)value;
- (void)addEvents:(NSSet * _Nonnull)values;
- (void)removeEvents:(NSSet * _Nonnull)values;
@end

@class NSUUID;

@interface EventTasks (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSDate * _Nullable date;
@property (nonatomic, copy) NSUUID * _Nullable id;
@property (nonatomic) BOOL isDone;
@property (nonatomic, copy) NSString * _Nullable text;
@property (nonatomic, strong) NSSet * _Nullable events;
@end


SWIFT_CLASS("_TtC20ProWatchOS_Watch_App17ExtensionDelegate")
@interface ExtensionDelegate : NSObject <WKExtensionDelegate>
- (void)applicationDidFinishLaunching;
- (void)applicationDidBecomeActive;
- (void)applicationWillResignActive;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS_NAMED("Feeling")
@interface Feeling : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@class Prothese;

@interface Feeling (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSDate * _Nullable date;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, strong) Prothese * _Nullable prothese;
@end


SWIFT_CLASS("_TtC20ProWatchOS_Watch_App19HealthStoreProvider")
@interface HealthStoreProvider : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end




SWIFT_CLASS_NAMED("Item")
@interface Item : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



@interface Item (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSDate * _Nullable timestamp;
@end


SWIFT_CLASS_NAMED("Liner")
@interface Liner : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



@interface Liner (SWIFT_EXTENSION(ProWatchOS_Watch_App))
- (void)addProtheseObject:(Prothese * _Nonnull)value;
- (void)removeProtheseObject:(Prothese * _Nonnull)value;
- (void)addProthese:(NSSet * _Nonnull)values;
- (void)removeProthese:(NSSet * _Nonnull)values;
@end


@interface Liner (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSString * _Nullable brand;
@property (nonatomic, copy) NSDate * _Nullable date;
@property (nonatomic) int16_t interval;
@property (nonatomic, copy) NSString * _Nullable linerID;
@property (nonatomic, copy) NSString * _Nullable model;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, strong) NSSet * _Nullable prothese;
@end


SWIFT_CLASS_NAMED("Locations")
@interface Locations : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



@interface Locations (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSUUID * _Nullable id;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double speed;
@property (nonatomic, copy) NSDate * _Nullable timestamp;
@property (nonatomic, copy) NSString * _Nullable trackID;
@end


SWIFT_CLASS_NAMED("Pain")
@interface Pain : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@class PainDrug;
@class PainReason;

@interface Pain (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSString * _Nullable condition;
@property (nonatomic, copy) NSString * _Nullable conditionIcon;
@property (nonatomic, copy) NSDate * _Nullable date;
@property (nonatomic) int16_t painIndex;
@property (nonatomic) double pressureMb;
@property (nonatomic) double stepCount;
@property (nonatomic) double tempC;
@property (nonatomic) double tempF;
@property (nonatomic) int16_t wearingAllProtheses;
@property (nonatomic, strong) PainDrug * _Nullable painDrugs;
@property (nonatomic, strong) PainReason * _Nullable painReasons;
@property (nonatomic, strong) Prothese * _Nullable prothese;
@end


SWIFT_CLASS_NAMED("PainDrug")
@interface PainDrug : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



@interface PainDrug (SWIFT_EXTENSION(ProWatchOS_Watch_App))
- (void)addPainObject:(Pain * _Nonnull)value;
- (void)removePainObject:(Pain * _Nonnull)value;
- (void)addPain:(NSSet * _Nonnull)values;
- (void)removePain:(NSSet * _Nonnull)values;
@end


@interface PainDrug (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSDate * _Nullable date;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, strong) NSSet * _Nullable pain;
@end


SWIFT_CLASS_NAMED("PainReason")
@interface PainReason : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



@interface PainReason (SWIFT_EXTENSION(ProWatchOS_Watch_App))
- (void)addPainsObject:(Pain * _Nonnull)value;
- (void)removePainsObject:(Pain * _Nonnull)value;
- (void)addPains:(NSSet * _Nonnull)values;
- (void)removePains:(NSSet * _Nonnull)values;
@end


@interface PainReason (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSDate * _Nullable date;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, strong) NSSet * _Nullable pains;
@end


SWIFT_CLASS_NAMED("Prothese")
@interface Prothese : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



@interface Prothese (SWIFT_EXTENSION(ProWatchOS_Watch_App))
- (void)addFeelingsObject:(Feeling * _Nonnull)value;
- (void)removeFeelingsObject:(Feeling * _Nonnull)value;
- (void)addFeelings:(NSSet * _Nonnull)values;
- (void)removeFeelings:(NSSet * _Nonnull)values;
@end


@interface Prothese (SWIFT_EXTENSION(ProWatchOS_Watch_App))
- (void)addPainsObject:(Pain * _Nonnull)value;
- (void)removePainsObject:(Pain * _Nonnull)value;
- (void)addPains:(NSSet * _Nonnull)values;
- (void)removePains:(NSSet * _Nonnull)values;
@end

@class WearingTimes;

@interface Prothese (SWIFT_EXTENSION(ProWatchOS_Watch_App))
- (void)addWearingTimesObject:(WearingTimes * _Nonnull)value;
- (void)removeWearingTimesObject:(WearingTimes * _Nonnull)value;
- (void)addWearingTimes:(NSSet * _Nonnull)values;
- (void)removeWearingTimes:(NSSet * _Nonnull)values;
@end


@interface Prothese (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSString * _Nullable kind;
@property (nonatomic, copy) NSDate * _Nullable maintage;
@property (nonatomic) int16_t maintageInterval;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable protheseID;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, strong) NSSet * _Nullable feelings;
@property (nonatomic, strong) Liner * _Nullable liner;
@property (nonatomic, strong) NSSet * _Nullable pains;
@property (nonatomic, strong) NSSet * _Nullable wearingTimes;
@end


SWIFT_CLASS_NAMED("RecurringEvents")
@interface RecurringEvents : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



@interface RecurringEvents (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSDate * _Nullable date;
@property (nonatomic, copy) NSString * _Nullable identifier;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic) double rhymus;
@property (nonatomic, strong) Contact * _Nullable contact;
@end


SWIFT_CLASS_NAMED("Report")
@interface Report : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



@interface Report (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSDate * _Nullable created;
@property (nonatomic, copy) NSDate * _Nullable endOfWeek;
@property (nonatomic, copy) NSDate * _Nullable startOfWeek;
@end

@class WCSession;

SWIFT_CLASS("_TtC20ProWatchOS_Watch_App16SessionDelegater")
@interface SessionDelegater : NSObject <WCSessionDelegate>
- (void)session:(WCSession * _Nonnull)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError * _Nullable)error;
- (void)session:(WCSession * _Nonnull)session didReceiveUserInfo:(NSDictionary<NSString *, id> * _Nonnull)userInfo;
- (void)session:(WCSession * _Nonnull)session didReceiveMessage:(NSDictionary<NSString *, id> * _Nonnull)message replyHandler:(void (^ _Nonnull)(NSDictionary<NSString *, id> * _Nonnull))replyHandler;
- (void)session:(WCSession * _Nonnull)session didReceiveApplicationContext:(NSDictionary<NSString *, id> * _Nonnull)applicationContext;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS_NAMED("SnapshotImage")
@interface SnapshotImage : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



@interface SnapshotImage (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic, copy) NSDate * _Nullable createdDate;
@property (nonatomic, copy) NSString * _Nullable fileName;
@end

@class NSCoder;

SWIFT_CLASS_NAMED("StartProthesenTimerIntent") SWIFT_AVAILABILITY(tvos,unavailable) SWIFT_AVAILABILITY(watchos,introduced=5.0) SWIFT_AVAILABILITY(macos,introduced=11.0) SWIFT_AVAILABILITY(ios,introduced=12.0)
@interface StartProthesenTimerIntent : INIntent
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end

@class StartProthesenTimerIntentResponse;

SWIFT_PROTOCOL_NAMED("StartProthesenTimerIntentHandling") SWIFT_AVAILABILITY(tvos,unavailable) SWIFT_AVAILABILITY(watchos,introduced=5.0) SWIFT_AVAILABILITY(macos,introduced=11.0) SWIFT_AVAILABILITY(ios,introduced=12.0)
@protocol StartProthesenTimerIntentHandling <NSObject>
- (void)handleStartProthesenTimer:(StartProthesenTimerIntent * _Nonnull)intent completion:(void (^ _Nonnull)(StartProthesenTimerIntentResponse * _Nonnull))completion;
@optional
- (void)confirmStartProthesenTimer:(StartProthesenTimerIntent * _Nonnull)intent completion:(void (^ _Nonnull)(StartProthesenTimerIntentResponse * _Nonnull))completion;
@end

enum StartProthesenTimerIntentResponseCode : NSInteger;
@class NSUserActivity;

SWIFT_CLASS_NAMED("StartProthesenTimerIntentResponse") SWIFT_AVAILABILITY(tvos,unavailable) SWIFT_AVAILABILITY(watchos,introduced=5.0) SWIFT_AVAILABILITY(macos,introduced=11.0) SWIFT_AVAILABILITY(ios,introduced=12.0)
@interface StartProthesenTimerIntentResponse : INIntentResponse
@property (nonatomic, readonly) enum StartProthesenTimerIntentResponseCode code;
- (nonnull instancetype)initWithCode:(enum StartProthesenTimerIntentResponseCode)code userActivity:(NSUserActivity * _Nullable)userActivity;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end

typedef SWIFT_ENUM(NSInteger, StartProthesenTimerIntentResponseCode, closed) {
  StartProthesenTimerIntentResponseCodeUnspecified = 0,
  StartProthesenTimerIntentResponseCodeReady = 1,
  StartProthesenTimerIntentResponseCodeContinueInApp = 2,
  StartProthesenTimerIntentResponseCodeInProgress = 3,
  StartProthesenTimerIntentResponseCodeSuccess = 4,
  StartProthesenTimerIntentResponseCodeFailure = 5,
  StartProthesenTimerIntentResponseCodeFailureRequiringAppLaunch = 6,
};


SWIFT_CLASS_NAMED("StopProthesenTimerIntent") SWIFT_AVAILABILITY(tvos,unavailable) SWIFT_AVAILABILITY(watchos,introduced=5.0) SWIFT_AVAILABILITY(macos,introduced=11.0) SWIFT_AVAILABILITY(ios,introduced=12.0)
@interface StopProthesenTimerIntent : INIntent
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end

@class StopProthesenTimerIntentResponse;

SWIFT_PROTOCOL_NAMED("StopProthesenTimerIntentHandling") SWIFT_AVAILABILITY(tvos,unavailable) SWIFT_AVAILABILITY(watchos,introduced=5.0) SWIFT_AVAILABILITY(macos,introduced=11.0) SWIFT_AVAILABILITY(ios,introduced=12.0)
@protocol StopProthesenTimerIntentHandling <NSObject>
- (void)handleStopProthesenTimer:(StopProthesenTimerIntent * _Nonnull)intent completion:(void (^ _Nonnull)(StopProthesenTimerIntentResponse * _Nonnull))completion;
@optional
- (void)confirmStopProthesenTimer:(StopProthesenTimerIntent * _Nonnull)intent completion:(void (^ _Nonnull)(StopProthesenTimerIntentResponse * _Nonnull))completion;
@end

enum StopProthesenTimerIntentResponseCode : NSInteger;

SWIFT_CLASS_NAMED("StopProthesenTimerIntentResponse") SWIFT_AVAILABILITY(tvos,unavailable) SWIFT_AVAILABILITY(watchos,introduced=5.0) SWIFT_AVAILABILITY(macos,introduced=11.0) SWIFT_AVAILABILITY(ios,introduced=12.0)
@interface StopProthesenTimerIntentResponse : INIntentResponse
@property (nonatomic, readonly) enum StopProthesenTimerIntentResponseCode code;
- (nonnull instancetype)initWithCode:(enum StopProthesenTimerIntentResponseCode)code userActivity:(NSUserActivity * _Nullable)userActivity;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end

typedef SWIFT_ENUM(NSInteger, StopProthesenTimerIntentResponseCode, closed) {
  StopProthesenTimerIntentResponseCodeUnspecified = 0,
  StopProthesenTimerIntentResponseCodeReady = 1,
  StopProthesenTimerIntentResponseCodeContinueInApp = 2,
  StopProthesenTimerIntentResponseCodeInProgress = 3,
  StopProthesenTimerIntentResponseCodeSuccess = 4,
  StopProthesenTimerIntentResponseCodeFailure = 5,
  StopProthesenTimerIntentResponseCodeFailureRequiringAppLaunch = 6,
};


SWIFT_CLASS("_TtC20ProWatchOS_Watch_App13TimeFormatter")
@interface TimeFormatter : NSFormatter
- (NSString * _Nullable)stringForObjectValue:(id _Nullable)value SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end








SWIFT_CLASS_NAMED("WearingTimes")
@interface WearingTimes : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end



@interface WearingTimes (SWIFT_EXTENSION(ProWatchOS_Watch_App))
@property (nonatomic) int32_t duration;
@property (nonatomic, copy) NSDate * _Nullable end;
@property (nonatomic, copy) NSDate * _Nullable start;
@property (nonatomic, strong) Prothese * _Nullable prothese;
@end


SWIFT_CLASS("_TtC20ProWatchOS_Watch_App14WorkoutManager")
@interface WorkoutManager : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class HKWorkoutSession;

@interface WorkoutManager (SWIFT_EXTENSION(ProWatchOS_Watch_App)) <HKWorkoutSessionDelegate>
- (void)workoutSession:(HKWorkoutSession * _Nonnull)workoutSession didChangeToState:(HKWorkoutSessionState)toState fromState:(HKWorkoutSessionState)fromState date:(NSDate * _Nonnull)date;
- (void)workoutSession:(HKWorkoutSession * _Nonnull)workoutSession didFailWithError:(NSError * _Nonnull)error;
@end

@class CLLocationManager;
@class CLLocation;

@interface WorkoutManager (SWIFT_EXTENSION(ProWatchOS_Watch_App)) <CLLocationManagerDelegate>
- (void)locationManager:(CLLocationManager * _Nonnull)manager didUpdateLocations:(NSArray<CLLocation *> * _Nonnull)locations;
@end

@class HKLiveWorkoutBuilder;
@class HKSampleType;

@interface WorkoutManager (SWIFT_EXTENSION(ProWatchOS_Watch_App)) <HKLiveWorkoutBuilderDelegate>
- (void)workoutBuilderDidCollectEvent:(HKLiveWorkoutBuilder * _Nonnull)workoutBuilder;
- (void)workoutBuilder:(HKLiveWorkoutBuilder * _Nonnull)workoutBuilder didCollectDataOfTypes:(NSSet<HKSampleType *> * _Nonnull)collectedTypes;
@end

#endif
#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#if defined(__cplusplus)
#endif
#pragma clang diagnostic pop
#endif
