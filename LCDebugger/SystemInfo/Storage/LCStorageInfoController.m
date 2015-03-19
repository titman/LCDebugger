//
//
//      _|          _|_|_|
//      _|        _|
//      _|        _|
//      _|        _|
//      _|_|_|_|    _|_|_|
//
//
//  Copyright (c) 2014-2015, Licheng Guo. ( http://nsobject.me )
//  http://github.com/titman
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "LCLog.h"
#import "LCUtils.h"
#import "LCStorageInfoController.h"
#import "LCGCD.h"

@interface LCStorageInfoController()
@property (nonatomic, strong) LCStorageInfo *storageInfo;

- (uint64_t)getTotalSpace;
- (uint64_t)getUsedSpace;
- (uint64_t)getFreeSpace;
- (NSUInteger)getSongCount;
- (NSUInteger)getTotalSongSize;
- (NSUInteger)updatePictureCount;
- (NSUInteger)updateVideoCount;

- (void)assetsLibraryDidChange:(NSNotification*)notification;
@end

@implementation LCStorageInfoController
@synthesize delegate;

@synthesize storageInfo;

#pragma mark - override

- (id)init
{
    if (self = [super init])
    {
        self.storageInfo = [[LCStorageInfo alloc] init];
    }
    return self;
}

#pragma mark - public

- (LCStorageInfo*)getStorageInfo
{
    self.storageInfo.totalSapce = [self getTotalSpace];
    self.storageInfo.usedSpace = [self getUsedSpace];
    self.storageInfo.freeSpace = [self getFreeSpace];
    self.storageInfo.songCount = [self getSongCount];
    self.storageInfo.totalSongSize = [self getTotalSongSize];
    
    [self updatePictureCount];
    [self updateVideoCount];
    
    return self.storageInfo;
}

#pragma mark - private

- (uint64_t)getTotalSpace
{    
    NSError         *error = nil;
    NSArray         *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary    *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:paths.lastObject error:&error];

    if (dictionary)
    {
        NSNumber *fileSystemSizeInBytes = dictionary[NSFileSystemSize];
        return [fileSystemSizeInBytes unsignedLongLongValue];
    }
    else
    {
        ERROR(@"attributesOfFileSystemForPat() has failed: %@", error.description);
        return 0.0;
    }
}

- (uint64_t)getUsedSpace
{
    NSError         *error = nil;
    NSArray         *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary    *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:paths.lastObject error:&error];
    
    if (dictionary)
    {
        NSNumber *fileSystemSize = dictionary[NSFileSystemSize];
        NSNumber *fileSystemFreeSize = dictionary[NSFileSystemFreeSize];
        uint64_t usedSize = [fileSystemSize unsignedLongLongValue] - [fileSystemFreeSize unsignedLongLongValue];
        return usedSize;
    }
    else
    {
        ERROR(@"attributesOfFileSystemForPat() has failed: %@", error.description);
        return 0.0;
    }
}

- (uint64_t)getFreeSpace
{
    NSError         *error = nil;
    NSArray         *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary    *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:paths.lastObject error:&error];
    
    if (dictionary)
    {
        NSNumber *fileSystemFreeSize = dictionary[NSFileSystemFreeSize];
        return [fileSystemFreeSize unsignedLongLongValue];
    }
    else
    {
        ERROR(@"attributesOfFileSystemForPat() has failed: %@", error.description);
        return 0.0;
    }
}

- (NSUInteger)getSongCount
{
    return [[MPMediaQuery songsQuery] items].count;
}

- (NSUInteger)getTotalSongSize
{
    // TODO:
    /*
    NSUInteger size = 0;
    NSArray *songs = [[MPMediaQuery songsQuery] items];
    
    for (MPMediaItem *item in songs)
    {
        NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
        AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL: url options:nil];
        CMTime duration = songAsset.duration;
        float durationSeconds = CMTimeGetSeconds(duration);
        AVAssetTrack *track = songAsset.tracks[0];
        [track loadValuesAsynchronouslyForKeys:@[@"estimatedDataRate"] completionHandler:^() { NSLog(@"%f", track.estimatedDataRate); }];
        float dr = track.estimatedDataRate;
        NSLog(@"dr: %f", dr);
    }
    */
    return 0;
}

- (NSUInteger)updatePictureCount
{
    self.storageInfo.pictureCount = 0;
    self.storageInfo.totalPictureSize = 0;
    
    [LCGCD dispatchAsync:LC_GCD_PRIORITY_DEFAULT block:^{
       
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        
        [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                if (asset)
                {
                    NSString *type = [asset  valueForProperty:ALAssetPropertyType];
                    if ([type isEqualToString:ALAssetTypePhoto])
                    {
                        self.storageInfo.pictureCount++;
                        
                        ALAssetRepresentation *rep = [asset defaultRepresentation];
                        self.storageInfo.totalPictureSize += rep.size;
                    }
                }
                else
                {
                    [LCGCD dispatchAsyncInMainQueue:^{
                       
                        [self.delegate storageInfoUpdated];
                    }];
                }
            }];
        } failureBlock:^(NSError *error) {
            ERROR(@"Failed to enumerate asset groups: %@", error.description);
        }];

        
    }];
    
    return 0;
}

- (NSUInteger)updateVideoCount
{
    self.storageInfo.videoCount = 0;
    self.storageInfo.totalVideoSize = 0;
    
    [LCGCD dispatchAsync:LC_GCD_PRIORITY_DEFAULT block:^{

    
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        
        [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                if (asset)
                {
                    NSString *type = [asset  valueForProperty:ALAssetPropertyType];
                    if ([type isEqualToString:ALAssetTypeVideo])
                    {
                        self.storageInfo.videoCount++;
                        
                        ALAssetRepresentation *rep = [asset defaultRepresentation];
                        self.storageInfo.totalVideoSize += rep.size;
                    }
                }
                else
                {
                    [LCGCD dispatchAsyncInMainQueue:^{
                       
                        [self.delegate storageInfoUpdated];
                    }];
                }
            }];
        } failureBlock:^(NSError *error) {
            ERROR(@"Failed to enumerate asset groups: %@", error.description);
        }];
        
    }];
    
    return 0;
}

- (void)assetsLibraryDidChange:(NSNotification*)notification
{
    [self updatePictureCount];
    [self updateVideoCount];
}

@end
