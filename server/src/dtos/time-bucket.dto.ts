import { ApiProperty, OmitType } from '@nestjs/swagger';
import { AssetOrder } from 'src/enum';
import { TimeBucketSize } from 'src/repositories/asset.repository';
import { Optional, ValidateBoolean, ValidateUUID } from 'src/validation';
import { IsEnum, IsInt, IsNotEmpty, IsString, Max, Min } from 'class-validator';
import { Type } from 'class-transformer';
import { PaginationResult } from 'src/utils/pagination';
import { hexOrBufferToBase64 } from 'src/dtos/asset-response.dto';

export class TimeBucketDto {
  @IsNotEmpty()
  @IsEnum(TimeBucketSize)
  @ApiProperty({ enum: TimeBucketSize, enumName: 'TimeBucketSize' })
  size!: TimeBucketSize;

  @ValidateUUID({ optional: true })
  userId?: string;

  @ValidateUUID({ optional: true })
  albumId?: string;

  @ValidateUUID({ optional: true })
  personId?: string;

  @ValidateUUID({ optional: true })
  tagId?: string;

  @ValidateBoolean({ optional: true })
  isArchived?: boolean;

  @ValidateBoolean({ optional: true })
  isFavorite?: boolean;

  @ValidateBoolean({ optional: true })
  isTrashed?: boolean;

  @ValidateBoolean({ optional: true })
  withStacked?: boolean;

  @ValidateBoolean({ optional: true })
  withPartners?: boolean;

  @IsEnum(AssetOrder)
  @Optional()
  @ApiProperty({ enum: AssetOrder, enumName: 'AssetOrder' })
  order?: AssetOrder;
}
export class LiteTimeBucketDto extends TimeBucketDto {
  @IsString()
  timeBucket!: string;

}
export class TimeBucketAssetDto extends TimeBucketDto {
  @IsString()
  timeBucket!: string;
}
export class LiteTimeBucketAssetDto extends LiteTimeBucketDto {
  @IsInt()
  @Min(1)
  @Type(() => Number)
  @Optional()
  page?: number;
}
export class LiteTimeBucketAssetResponseDto {
  @IsString()
  id!: string;

  @ApiProperty()
  isFavorite!: boolean;

  @ApiProperty()
  isArchived!: boolean;

  @ApiProperty()
  isTrashed!: boolean;

  @ApiProperty()
  thumbhash?: string | null;

  @ApiProperty()
  localDateTime!: Date;

  @ApiProperty({ type: 'integer' })
  height!: number;

  @ApiProperty({ type: 'integer' })
  width!: number;
}

export class TimeBucketResponseDto {
  @ApiProperty({ type: 'string' })
  timeBucket!: string;

  @ApiProperty({ type: 'integer' })
  count!: number;
}
export interface LiteTimeBucketDto {
  id: string;
  isFavorite: boolean;
  isArchived: boolean;
  thumbhash: string;
  localDateTime: Date;
  height: number;
  width: number;
}
export class LiteTimeBucketResponseDto {
  @ApiProperty({ type: [LiteTimeBucketAssetResponseDto] })
  liteAssets!: LiteTimeBucketAssetResponseDto[];

  @ApiProperty()
  hasNextPage!: boolean
}

