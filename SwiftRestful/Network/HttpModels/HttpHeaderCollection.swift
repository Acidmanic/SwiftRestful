//
//  HttpHeaderCollection.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/6/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation

public class HttpHeaderCollection{
    public static let ContentType="Content-Type"
    public static let TextContentType="application/text"
    public static let JsonContentType="application/json"
    public static let XmlContentType="application/xml"
    public static let FormUrlContentType="application/x-www-form-urlencoded; charset=utf-8"
    public static let Accept="Accept"
    public static let Authorization="Authorization"
    public static let AuthorizationBearerPrefix="bearer "
    public static let AcceptEncoding="Accept-Encoding"
    public static let AcceptCharset="Accept-Charset"
    public static let EncodingGzip="gzip"
    public static let EncodingCompress="compress"
    public static let CharsetUtf8="utf-8"
}
