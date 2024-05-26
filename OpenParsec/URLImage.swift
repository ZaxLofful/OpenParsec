import SwiftUI

struct URLImage<Placeholder:View, RemoteImage:View>:View
{
	let url:URL?
	let output:(Image) -> RemoteImage
	let placeholder:() -> Placeholder

	@State private var _remoteData:UIImage? = nil

	var body:some View
	{
		if let img = _remoteData
		{
			output(Image(uiImage:img))
		}
		else
		{
			placeholder()
				.onAppear
				{
					var request = URLRequest(url:url!)
					request.httpMethod = "GET"
					request.setValue("image/jpeg", forHTTPHeaderField:"Content-Type")
					request.setValue("application/json", forHTTPHeaderField:"Accept")
					request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Mobile/15E148 Safari/604.1", forHTTPHeaderField:"User-Agent")
			
					let task = URLSession.shared.dataTask(with:request)
					{ (data, response, error) in
						DispatchQueue.main.async
						{
							if let data = data, let uiImage = UIImage(data:data)
							{
								_remoteData = uiImage
							}
						}
					}
					task.resume()
				}
		}
	}
}
