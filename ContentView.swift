//
//  ContentView.swift
//  Neu Music Player
//
//  Created by Marlon Raskin on 3/30/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import SwiftUI

class Song: ObservableObject {
	let title: String = "Low Life"
	let artist: String = "Future ft. The Weeknd"
	let duration: TimeInterval = 120
	@Published var currentTime: TimeInterval = 50
	let coverArt: UIImage = UIImage(named: "BurningFlower")!
}

struct ContentView: View {

	@ObservedObject var song = Song()

	var body: some View {
		GeometryReader { geometry in
			ZStack {
				LinearGradient(gradient: Gradient(colors: [
					.bgGradientTop,
					.bgGradientBottom
				]),
							   startPoint: .top,
							   endPoint: .bottom)
					.edgesIgnoringSafeArea(.all)
				VStack {
					HStack {
						UtilityButton(imageName: "arrow.left", size: 50, symbolConfig: .navButtonConfig)
							.padding(.leading, 40)
						Spacer()
						Text("NOW PLAYING")
							.foregroundColor(.buttonColor)
							.font(Font.system(.headline)
								.smallCaps())
						Spacer()
						UtilityButton(imageName: "line.horizontal.3", size: 50, symbolConfig: .navButtonConfig)
							.padding(.trailing, 40)
					}

					CoverArtView(size: geometry.size.width * 0.8)
						.padding(.top, 16)
						.padding(.bottom, 10)

					Text(self.song.title)
						.font(Font.system(.title).weight(.semibold))
						.foregroundColor(.buttonColor)

					Text(self.song.artist)
						.padding(.top, 8)
						.font(Font.system(.callout).weight(.light))
						.foregroundColor(.buttonColor)

					Spacer()

					PlayerProgressView(song: self.song)

					Spacer()

					HStack {
						Spacer()
						UtilityButton(imageName: "backward.fill",
									  size: 70,
									  symbolConfig: .playbackControlsConfig)
						PlayPauseButton()
							.frame(width: 80, height: 80)
							.padding(.horizontal, 14)
						UtilityButton(imageName: "forward.fill",
									  size: 70,
									  symbolConfig: .playbackControlsConfig)
						Spacer()
					}
					.padding(.bottom, 25)
				}
			}
		}
	}
}


struct PlayPauseButton: View {

	@State var isPlaying = false

	var body: some View {
		Button(action: {
			self.isPlaying.toggle()
		}) {
			ZStack {
				Circle()
					.fill(LinearGradient(gradient: Gradient(colors: [
						.pauseLightOrange,
						.pauseDarkOrange
					]), startPoint: isPlaying ? .topLeading : .bottomTrailing,
						endPoint: isPlaying ? .bottomTrailing : .topLeading))
				Circle()
					.fill(LinearGradient(gradient: Gradient(colors: [
						.pauseLightOrange,
						.pauseDarkOrange
					]), startPoint: isPlaying ? .bottomTrailing : .topLeading,
						endPoint: isPlaying ? .topLeading : .bottomTrailing))
					.padding(3)

				Image(systemName: isPlaying ? "pause" : "play.fill")
					.foregroundColor(.white)
					.font(Font.system(.callout).weight(.bold))

			}
			.shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 5)
			.shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5)
			Text("")
		}
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}


struct UtilityButton: View {

	var imageName: String
	var size: CGFloat
	var symbolConfig: UIImage.SymbolConfiguration

	var body: some View {
		Button(action: {
			// TODO: - Add the back navigation later
		}) {
			ZStack {
				Circle()
					.fill(LinearGradient(gradient: Gradient(colors: [
						.bgGradientTop,
						.bgGradientBottom,
					]),
										 startPoint: .bottomTrailing,
										 endPoint: .topLeading))
					.frame(width: size, height: size)
				
				Image(uiImage: UIImage(systemName: imageName, withConfiguration: symbolConfig)!)
//					.resizable()
					.font(Font.system(.headline).weight(.bold))
					.aspectRatio(contentMode: .fit)
					.foregroundColor(.buttonColor)
					.frame(width: size * 0.90, height: size * 0.90)
//					.padding(12)
					.background(
						LinearGradient(gradient: Gradient(colors: [.bgGradientTop, .bgGradientBottom]),
									   startPoint: .topLeading,
									   endPoint: .bottomTrailing))
					.clipShape(Circle())
			}
			.shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 5)
			.shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5)

		}
		.shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 5)
		.shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5)
	}
}

struct CoverArtView: View {

	var size: CGFloat = 300

	var body: some View {
		ZStack {
			Circle()
				.fill(Color.bgGradientBottom.opacity(0.7))
				.frame(width: size, height: size)
			Image("BurningFlower")
				.resizable()
				.font(Font.system(.headline).weight(.bold))
				.aspectRatio(contentMode: .fill)
				.foregroundColor(.buttonColor)
				.frame(width: size * 0.93, height: size * 0.95)
				.background(
					LinearGradient(gradient: Gradient(colors: [.bgGradientTop, .bgGradientBottom]),
								   startPoint: .topLeading,
								   endPoint: .bottomTrailing))
				.clipShape(Circle())
		}
		.shadow(color: Color.black.opacity(0.25), radius: 12, x: 20, y: 25)
		.shadow(color: Color.white.opacity(0.05), radius: 8, x: -20, y: -20)
	}
}

struct PlayerProgressView: View {

	var dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "m:ss"
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		return formatter
	}()

	@ObservedObject var song: Song

	var trackRadius: CGFloat = 3

	var body: some View {
		VStack {
			HStack {
				Text("\(formattedTimeFor(timeInterval: song.currentTime))")
				Spacer()
				Text("\(formattedTimeFor(timeInterval: song.duration))")
			}
			.foregroundColor(.buttonColor)
			.font(Font.system(.caption))


			ZStack {
				RoundedRectangle(cornerRadius: 6)
					.fill(LinearGradient(gradient: Gradient(stops: [
						Gradient.Stop(color: .bgGradientTop, location: 0.2),
						Gradient.Stop(color: Color.black.opacity(0.7), location: 0.7)
					]), startPoint: .bottom, endPoint: .top))
					.frame(height: trackRadius * 2)

				GeometryReader { geometry in
					HStack {
						RoundedRectangle(cornerRadius: self.trackRadius)
							.fill(LinearGradient(gradient: Gradient(colors: [.trackOrange, .trackYellow]),
												 startPoint: .leading,
												 endPoint: .trailing))
							.frame(width: geometry.size.width * self.percentageCompleteForSong(),
								   height: self.trackRadius * 2)
						Spacer(minLength: 0)
					}
				}

				GeometryReader { geometry in
                    HStack {
                        Circle()
                            .fill(
                                RadialGradient(gradient: Gradient(stops: [
                                    Gradient.Stop(color: .trackYellow, location: 0.0),
                                    Gradient.Stop(color: .bgGradientBottom, location: 0.00001),
                                    Gradient.Stop(color: .bgGradientTop, location: 1),
                                ]), center: .center, startRadius: 6, endRadius: 40)
                        )
                            .frame(width: 40, height: 40)
                            .padding(.leading, geometry.size.width * self.percentageCompleteForSong() - 20)
							.gesture(
								DragGesture()
									.onChanged({ (value) in
										self.song.currentTime = self.time(for: value.location.x, in: geometry.size.width)
									})
						)
                        Spacer(minLength: 0)
                    }
                }
			}
		.frame(height: 40)
		}
		.padding(.horizontal, 30)
	}

	func formattedTimeFor(timeInterval: TimeInterval) -> String {
		let date = Date(timeIntervalSinceReferenceDate: timeInterval)
		return dateFormatter.string(from: date)
	}

	func time(for location: CGFloat, in width: CGFloat) -> TimeInterval {
		let percentage = location / width
		let time = song.duration * TimeInterval(percentage)

		if time < 0 {
			return 0
		} else if time > song.duration {
			return song.duration
		}

		return time
	}

	func percentageCompleteForSong() -> CGFloat {
		return CGFloat(song.currentTime / song.duration)
	}
}



