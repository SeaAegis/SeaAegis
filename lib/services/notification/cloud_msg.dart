import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
// import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class FirebaseCloudMessaging {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "seaaegis",
      "private_key_id": "ed1aeb48486f1e91a89ac059754a3aa2ca109c37",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDjUxvDG8ylJYWP\nDo0rRwOvv6u2Ifv67rHurXva0Gw9IBQkTnM+Xap4mdVog8ET3zgzgay6Titvc6By\npFq5YbEr4Wun2mMhE+HA8uWTefb6O2pXS8vohTH/7Om3JkZSHd3BWZDwKix4Vf5j\nWUXUVNk6Uh1XzI0OUpT8gKAGnoW0a9HvpXv10JorAdS+Dak/a+WFRyaWDULCgeCk\nRjDboRPpxaV2PRWqZ2m0XSkWwHyEZM1ebezx4DHPypca0dvaEAaf4ORd0SxYk/Uf\nuMnq/S6Ilmc58dzEGTk3G1bVBDco0yu1v7A+p9qLTKmsZ3un+vvpo/7HDK/Wrre1\n6rRJkEuTAgMBAAECggEACJjXh3DxM9uv6eGcgCL+5jIi/c/aNjq5uvOPqA5S0Zr5\neAgJfrXPISF8OygkcKpz9yqzzBXxuZTPYBaMIc+qgiTTy/TL4+/bDU+CVCn8J6mA\nk42XyBLlea7NhfIqHafof4vyGcsWhHSIGtzA8c9Fqdl6J5xiR0TjQotgwe9T0idh\neNq28eO+9gFOvdLhtoh0XnbgvHjTit45wjNsfCMW1dRVjgt6lbqxZuxP7XydO0Wj\nvZm/V3WjbldMj4Y4jxl21kPc3nXmx22mvztSi5tuIQgLlZff3UkAnFThqCP7L5wQ\nL6D4/Alae/PmH9Pf2O33YY9tjeESQE/zZToGkTmEWQKBgQD1Ui2xtrK7bkTK8kCN\nxM/wAs3MYDGs1WSQAaJNRUuuTdHCf11WnrzLl5lOpXKxS5wn7LPwOQlLKbsHL7Ul\n1345aP7kAP5uTrRyRJIwVYj7t+8SmgXF/7hVuhKstCkLTxRJ/SaY0ZSBRqfD7CID\ne6FSKqIbm62xNg1oRJ5xy4KhSwKBgQDtOGGNWOtGNMiHiTgcNfTzteLXNGe/EQf5\nDfAYuQfhxSWu+KBdklNgimIoci1xKosVzA2oG4iRcB7b57noOghvTTlelGp/7aGF\nI/Y7ftYXZV7p3Kj0t5WgyAWeZyEqwbSS8aX9p5rplPZ8vDENSkV9YY0bsCKb8pGJ\nk1brcjfZ2QKBgEkVRk+fIff8jbn4GYsiit/xteWg8quOlvrfwb5LWpR+0nKjBud7\nOrtcWmu3lkeDQu4R8jkqhL5DnFgzuj+fxxbLVMQQF7w87jzseLC1iq2SykI8aGPo\nHr5LRKz2rxOTZ3PzWsBED33D0s7nVeq7tf+Ie+rFoiUc+TmK17kG68+pAoGARGlC\nGNVP5ItMWWoFOH2HCtGlfZKraLqspfKTD04tK7sDRxaEiPet++VssWVcHYq7Wanj\nNlvaYrcG7zxArOwviommxdPfcs1BC3h3hmjprQ2a9a6hOxHGoPuOQ0RSmFYMkWQH\nDsPLNRm0i/xp2P9WUvZTD20YTgkCV76aDoR9/uECgYB0KG0x2pp3ZQbh9zYcCAVN\nGPma9ugpxCXePaWIesxYzDWIWxAzlg6NJ8VaD8qrfZrHeInzL8U7cfU45CsxZI2p\nXpbe9DzJBMot8DNCtNqZsxG/yasAXVIZLFfmRe6bTlWov58CviyV9NLSlUl+A3/0\nkzgx7i3hD31o1ySSYX25ng==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "seaaegis-cloud-messaging@seaaegis.iam.gserviceaccount.com",
      "client_id": "115716461446106513369",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/seaaegis-cloud-messaging%40seaaegis.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Obtain the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    // Close the HTTP client
    client.close();

    // Return the access token
    return credentials.accessToken.data;
  }
}
