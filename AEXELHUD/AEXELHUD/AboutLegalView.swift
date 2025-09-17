import SwiftUI

struct AboutLegalView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("AEXEL HUD").font(.largeTitle.bold())
                Text("© 2025 AEXELGROUP").font(.headline)
                Text("Bundle ID: com.aexelgroup.hudapp").font(.subheadline).foregroundStyle(.secondary)
                
                Group {
                    Text("Disclaimer").font(.title2.bold())
                    Text("This app provides driver-assistance information only. Always obey traffic laws, signage, and road conditions. Keep your attention on the road at all times. The authors and AEXELGROUP are not liable for any damages or consequences arising from its use.")
                }
                
                Group {
                    Text("Privacy").font(.title2.bold())
                    Text("Location data is used to compute navigation and display speed. Audio may be used for voice guidance. No analytics or tracking are enabled in this prototype. Add your own privacy policy and data handling controls before public distribution.")
                }
                
                Group {
                    Text("License (MIT)").font(.title2.bold())
                    Text("""MIT License

Copyright (c) 2025 AEXELGROUP

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
""").font(.footnote).textSelection(.enabled)
                }
            }
            .padding()
        }
    }
}
