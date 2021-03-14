import 'package:meta/meta.dart';
import 'api/api_endpoints.dart';
import 'package:dio/dio.dart';

class PlaceRepository {
  Future<dynamic> fetchPlaces() async {
    try {
      var response = await Dio().get(Api.all_places,
          options: Options(headers: {
            "Authorization": "Bearer " +
                "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMDlkZjkxYzJlYTMyMzUxZDVhMzY1Y2RlMTBjM2FlZTNiNzI0MTI5NTdiZjc2OGViMDhjMjMzNThjYTI2NjI0YmQ5Y2ZiNjEyZmYzNTk1OWIiLCJpYXQiOiIxNjEyMTE2OTQ1LjU4Mzk3MCIsIm5iZiI6IjE2MTIxMTY5NDUuNTgzOTc1IiwiZXhwIjoiMTY0MzY1Mjk0NS41Njk1MDYiLCJzdWIiOiIzIiwic2NvcGVzIjpbXX0.pxu1bSp3VhLfLi6aIUpPLdnAjJMFrQjpKZ5T1czRvq5I-XUo90eQyJ9DFz9_wG--imCTqUC0n8a7ukKfgKI86RUHjtUU8vW-Zz6UMSXXNDYVknmr2z6rBKD6B0xr_BzyOKNAbhHp9d3JayV7itL-2HwYVfuKjejVGFt1lhMu2Srgd5Vhm3ngqV0H7N_iKhnYCYdJPVXHybQU4JFBxLVUR3gLvtbKXjM_vT8n_I3FHsR75BbQlibhwggSzWb_t5YUnCPwJrGp0NJenhdl1ecZQQCc8b6GxC8y3zSaFtWlHMbGi2fNtmbkuplHNS-fhQEmU52lo35OJxGdSLgS9MNzGyaU0eCKGoNMj6k8wuOSmY5Uv-dPZ7LXH89phSb58bLci6lC-MbXf4FnetcUWLo7FeyMBqgGVEWZcyd1RLaBg_SU2xVVwsUo87UH15ZS1p1MotVLRIHlJ1M73Rg6EpWYS2BS9hT_6mM46BRnsEO1FDDV8N9j5HjpAMB-_Pjb2ChqUoPoKTo6jsAga18-WQrPMeyP52avwo9X9i-FMLpYG8Z-Pc8KZZSaIkx06PEeWtu7RR8dGGomM0d-XXlLXjGEoY-Nq0xzTK62WSoed_ZdNw7SPyB8YRvc4UUrt7ypjGkLUJbfTwLJtQDoAV-GdaikhD_AKzzk-KCCRHPsqnh5UYg"
          }) // options.headers["Authorization"] = "Bearer " + token;
          );
      print(response.toString());
      return 's';
      response.data["places"];
    } catch (e) {
      throw ("Incorrect email and password");
    }
  }
}
