import { Controller, Get, Query } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { AssetResponseDto, hexOrBufferToBase64 } from 'src/dtos/asset-response.dto';
import { AuthDto } from 'src/dtos/auth.dto';
import { LiteTimeBucketAssetResponseDto, LiteTimeBucketDto, LiteTimeBucketResponseDto, TimeBucketAssetDto, TimeBucketDto, TimeBucketResponseDto } from 'src/dtos/time-bucket.dto';
import { AssetStatus, Permission } from 'src/enum';
import { Auth, Authenticated } from 'src/middleware/auth.guard';
import { TimelineService } from 'src/services/timeline.service';


@ApiTags('Timeline')
@Controller('timeline')
export class TimelineController {
  constructor(private service: TimelineService) { }

  @Get('buckets')
  @Authenticated({ permission: Permission.ASSET_READ, sharedLink: true })
  getTimeBuckets(@Auth() auth: AuthDto, @Query() dto: TimeBucketDto): Promise<TimeBucketResponseDto[]> {
    return this.service.getTimeBuckets(auth, dto);
  }

  @Get('bucket')
  @Authenticated({ permission: Permission.ASSET_READ, sharedLink: true })
  getTimeBucket(@Auth() auth: AuthDto, @Query() dto: TimeBucketAssetDto): Promise<AssetResponseDto[]> {
    return this.service.getTimeBucket(auth, dto) as Promise<AssetResponseDto[]>;
  }

  @Get('liteBucket')
  @Authenticated({ permission: Permission.ASSET_READ, sharedLink: true })
  async getLiteTimeBucket(@Auth() auth: AuthDto, @Query() dto: LiteTimeBucketDto): Promise<LiteTimeBucketResponseDto> {
    const paginated = await this.service.getLiteTimeBucket(auth, dto);
    const liteAssets = paginated.items.map((item) => {
      const liteAsset: LiteTimeBucketAssetResponseDto = {
        id: item.id!,
        isFavorite: item.isFavorite || false,
        isArchived: item.isArchived || false,
        isTrashed: item.status === AssetStatus.TRASHED,
        localDateTime: item.localDateTime!,
        height: item.height!,
        width: item.width!,
        thumbhash: item.thumbhash ? hexOrBufferToBase64(item.thumbhash) : null
      };

      return liteAsset;
    });
    return {
      liteAssets,
      hasNextPage: paginated.hasNextPage
    }
  }

}
