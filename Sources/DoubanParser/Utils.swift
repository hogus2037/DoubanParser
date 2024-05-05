
import Foundation

enum Utils {
    /// 从url 里截取 subject id
    /// url:/subject/36621399/
    ///
    static func parseSubjectId(url: String) -> Int {
        let components = url.components(separatedBy: "/").filter { $0.isEmpty == false }
        return Int(components.last!)!
    }
    
    static func parsePTStringToMinutes(ptString: String) -> Int? {
        // 如果字符串不以"PT"开头，则无法解析
        guard ptString.hasPrefix("PT") else {
            return nil
        }
        
        // 从字符串中提取小时和分钟
        var hourString = ""
        var minuteString = ""
        
        // 从第 2 个字符开始循环，跳过"PT"
        for char in ptString.dropFirst(2) {
            // 如果是数字，则追加到 hourString 或 minuteString 中
            if char.isNumber {
                if minuteString.isEmpty && hourString.isEmpty {
                    hourString.append(char)
                } else {
                    minuteString.append(char)
                }
            } else {
                // 如果遇到 "H"，则表示小时
                if char == "H" {
                    continue
                }
                // 如果遇到 "M"，则表示分钟
                if char == "M" {
                    break
                }
                // 如果遇到其他字符，则格式错误，无法解析
                return nil
            }
        }
        
        // 将小时和分钟转换为整数
        guard let hours = Int(hourString), let minutes = Int(minuteString) else {
            return nil
        }
        
        // 计算总的分钟数
        return hours * 60 + minutes
    }
}
