import 'dart:io';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

// Android 애뮬레이터 Localhost
const emulatorIp = '10.0.2.2:3000';
// iOS 시뮬레이터 Localhost
const simulatorIp = '127.0.0.1:3000';

final ip = Platform.isAndroid ? emulatorIp : simulatorIp;
