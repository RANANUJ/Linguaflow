
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Allow cross-origin requests during development.
  app.enableCors({
    origin: true,
    credentials: true,
  });

  // Allow connections from your phone and computer.
  await app.listen(process.env.PORT ?? 3000, '0.0.0.0');
}

bootstrap();
