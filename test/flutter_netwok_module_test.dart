import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_netwok_module/flutter_netwok_module.dart';

class MyNetworkConfig extends NetworkConfiguration {
  MyNetworkConfig({required super.baseURL, super.adapters});
}

void main() {
  _simpleGetRequest(); // sample get request
  // _simpleInterceptorFailedGetRequest(); // interceptor can block your request
  // _simpleInterceptorSuccessGetRequest(); // interceptor request
  // _simpleAdapterSuccessGetRequest(); // interceptor request
}

void _simpleGetRequest() {
  test("Network request test", () async {
    NetworkClient client = NetworkClient(
        config: MyNetworkConfig(
            baseURL: BaseURL(
              baseURL: "https://pastebin.com/",
            ),
            adapters: [MyAdapter()]));
    var res = await client
        .request<SampleEntity>(SamplePath(parser: SampleEntityParser()));
    res.fold((l) => print(l.message), (r) => print(r.object));
  });
}

// void _simpleInterceptorFailedGetRequest() {
//   test("Network interceptor failed request test", () async {
//     NetworkConfiguration config = NetworkConfiguration(
//         baseURL: BaseURL(
//       baseURL: "https://pastebin.com/",
//     ));
//     NetworkClient client = NetworkClient(config: config);
//     client.addInterceptors([MyInterCeptorFailed()]);
//     var res = await client
//         .request<SampleEntity>(SamplePath(parser: SampleEntityParser()));
//     res.fold((l) => print(l.message), (r) => print(r.rowObject));
//   });
// }

// void _simpleInterceptorSuccessGetRequest() {
//   test("Network interceptor success request test", () async {
//     NetworkConfiguration config = NetworkConfiguration(
//         baseURL: BaseURL(
//       baseURL: "https://pastebin.com/",
//     ));
//     NetworkClient client = NetworkClient(config: config);
//     client.addInterceptors([MyInterCeptorSuccess()]);
//     var res = await client
//         .request<SampleEntity>(SamplePath(parser: SampleEntityParser()));
//     res.fold((l) => print(l.message), (r) => print(r.object!.objectId));
//   });
// }

// void _simpleAdapterSuccessGetRequest() {
//   test("Network Adapter success request test", () async {
//     NetworkConfiguration config = NetworkConfiguration(
//         baseURL: BaseURL(
//       baseURL: "https://pastebin.com/",
//     ));
//     NetworkClient client = NetworkClient(config: config);
//     client.addAdopters([MyAdapter()]);
//     var res = await client.request(SamplePath(parser: SampleEntityParser()));
//     res.fold((l) => print(l.message), (r) => print(r.rowObject));
//   });
// }

class SamplePath extends RequestApi {
  SamplePath({required super.parser});

  @override
  String get endPath => "raw/4Nngn37p";
}

class SampleEntity extends Entity {
  String objectId = "20";

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

class SampleEntityParser extends EntityParser<SampleEntity> {
  @override
  SampleEntity parseObject(Map<String, dynamic> json) {
    return SampleEntity();
  }
}

// class MyInterCeptorFailed extends Interceptor {
//   @override
//   Future<Either<NetworkFailure, RequestApi>> onRequest(
//       RequestApi endPath, NetworkClient client) async {
//     return const Left(
//         NetworkFailure(statusCode: 300, message: "Failed from Interceptor"));
//   }
// }

// class MyInterCeptorSuccess extends Interceptor {
//   @override
//   Future<Either<NetworkFailure, RequestApi>> onRequest(
//       RequestApi endPath, NetworkClient client) async {
//     return Right(endPath);
//   }
// }

class MyAdapter extends Adapter {
  static bool isCalled = false;
  @override
  Future<Result<NetworkFailure, NetworkResponseModel<T>>>
      onResponse<T extends Entity>(
          Result<NetworkFailure, NetworkResponseModel<T>> response,
          RequestApi endPath,
          NetworkClient client) async {
    print("here");
    print(endPath.endPath);
    if (!MyAdapter.isCalled) {
      MyAdapter.isCalled = true;
      var res = await client
          .request<SampleEntity>(SamplePath(parser: SampleEntityParser()));
      return res.fold((l) => Failure(l), (r) => client.request(endPath));
    }

    return response;
  }
}

// class MyFailedAdapter extends Adapter {
//   static bool isCalled = false;
//   @override
//   Future<Either<NetworkFailure, NetworkResponseModel<T>>>
//       onResponse<T extends Entity>(
//           Either<NetworkFailure, NetworkResponseModel<T>> response,
//           RequestApi endPath,
//           NetworkClient client) async {
//     print(endPath.endPath);
//     if (!MyAdapter.isCalled) {
//       MyAdapter.isCalled = true;
//       var res = await client
//           .request<SampleEntity>(SamplePath(parser: SampleEntityParser()));
//       return res.fold((l) => Left(l), (r) => client.request(endPath));
//     } else {
//       return const Left(
//           NetworkFailure(statusCode: 300, message: "Failed from Interceptor"));
//     }
//   }
// }
