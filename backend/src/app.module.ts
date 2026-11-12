import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';

import { TranslationModule } from './translation/translation.module';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { StoriesModule } from './stories/stories.module';

@Module({
  imports: [
    // Load environment variables from the .env file.
    ConfigModule.forRoot({
      isGlobal: true,
    }),

    // Connect the NestJS backend to MongoDB Atlas.
    MongooseModule.forRootAsync({
      inject: [ConfigService],
      useFactory: async (configService: ConfigService) => ({
        uri: configService.get<string>('MONGODB_URI'),
      }),
    }),

    // Application modules.
    TranslationModule,
    AuthModule,
    UsersModule,
    StoriesModule,
  ],
})
export class AppModule {}