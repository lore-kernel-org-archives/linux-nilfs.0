From: Chaitanya Kulkarni <chaitanyak-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 19/19] block: pass a block_device and opf to bio_reset
Date: Tue, 18 Jan 2022 22:16:06 +0000
Message-ID: <d7068c68-17f5-86d3-6901-b747d41ac346@nvidia.com>
References: <20220118071952.1243143-1-hch@lst.de>
 <20220118071952.1243143-20-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ZSiXN0jlndrXjj1b4wa9kUUdCNmCG91kc9Ols66x+s=;
 b=HBcpijMicyIwzHnSbIlGaNqNINL1v7Pjes5O88tizzN3H8L5SSm8rqLvBvwmM58oXuD/2epxA4KiaSeLO7Ql5OyhrpnNDUx++hQukKoT0+VTH3OWE7tyj+bWzrAtE6pfWa91u5Wk9yEovSbKfBTXALnFtJjMp5zvlMCP68VJQZMWvWfcIdTfF6Y0F1Jsh1l2K6B5HbeedD900uuln72ZVygE3BGLF9ueMGynuSsQi+AE/nb6Ol4RJafPbebVlL6HjKLDH+kPOIaQSRJq++id31s2xcpl6o5Y7HKnmiHChJBeTGyWZmy1A7lojkWtdFchU9YWfjvqnyXHHpNNksPFXg==
In-Reply-To: <20220118071952.1243143-20-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Content-ID: <CB5A6D32F2CA9E46A3FB208AE3C086E5-asWib9pRmPqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konstantin Komarov <almaz.alexandrovich-m5I1DM4ARimttCpgsWEBFlaTQe2KTcn/@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Md . Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, =?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau-Sxgqhf6Nn4Bhl2p70BpVqQ@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org" <ntfs3@l>

T24gMS8xNy8yMiAxMToxOSBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFBhc3MgdGhl
IGJsb2NrX2RldmljZSB0aGF0IHdlIHBsYW4gdG8gdXNlIHRoaXMgYmlvIGZvciBhbmQgdGhlDQo+
IG9wZXJhdGlvbiB0byBiaW9fcmVzZXQgdG8gb3B0aW1pemUgdGhlIGFzc2lnbWVudC4gIEEgTlVM
TCBibG9ja19kZXZpY2UNCj4gY2FuIGJlIHBhc3NlZCwgYm90aCBmb3IgdGhlIHBhc3N0aHJvdWdo
IGNhc2Ugb24gYSByYXcgcmVxdWVzdF9xdWV1ZSBhbmQNCj4gdG8gdGVtcG9yYXJpbHkgYXZvaWQg
cmVmYWN0b3Jpbmcgc29tZSBuYXN0eSBjb2RlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0
b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdl
ZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0K
