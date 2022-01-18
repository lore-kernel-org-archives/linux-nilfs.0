From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 17/19] block: pass a block_device and opf to bio_alloc
Date: Tue, 18 Jan 2022 22:14:17 +0000
Message-ID: <8f26d2c5-2ff3-68b6-c883-567f16bf57f8@nvidia.com>
References: <20220118071952.1243143-1-hch@lst.de>
 <20220118071952.1243143-18-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSJliUmMKGywiR7aX2A0K7VaQAgJnTUG4RzJwOOxmtY=;
 b=pLVZEiVMX0zPE2061UG/7mMXj+M4+oYQfJxoqh5U8gcSd/4phNII+UDan9y6AKa0ylV41BjaDy2pKeJxWGCa+RxGDdCddb8Xq4iVX9C9RzKna/GFHnU6aWoU5lAq76t7r2xQWSjVnFFjsmKhGStLxD4zk++2K5lyS9/VH4gLYL31Q74ltNxKUsgxWsfBSPsFm+YsLxrgX34k7msAGjmxbffPzke999a6cj99ZZ2P/ySJboeNXdwjyzFbUo0zEZ0rJ08ZBlGr5MTb/F6Tf2fQ6rX97R81rEJj/7ElPqCbZs/cTynrFzt+F2KysLuqrp/ghvXFcZqII+adsAD5qgvhYg==
In-Reply-To: <20220118071952.1243143-18-hch@lst.de>
Content-Language: en-US
Content-ID: <C34C2F0A08E43545A50616A425CD9E1A@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Mike Snitzer <snitzer@redhat.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Andrew Morton <akpm@linux-foundation.org>, "Md . Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, =?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.co>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "ntfs3@lists.linux.dev" <ntfs3@l>

T24gMS8xNy8yMiAxMToxOSBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFBhc3MgdGhl
IGJsb2NrX2RldmljZSBhbmQgb3BlcmF0aW9uIHRoYXQgd2UgcGxhbiB0byB1c2UgdGhpcyBiaW8g
Zm9yIHRvDQo+IGJpb19hbGxvYyB0byBvcHRpbWl6ZSB0aGUgYXNzaWdtZW50LiAgTlVMTC8wIGNh
biBiZSBwYXNzZWQsIGJvdGggZm9yIHRoZQ0KDQoncy9hc3NpZ21lbnQvYXNzaWdubWVudC8nDQoN
Cj4gcGFzc3Rocm91Z2ggY2FzZSBvbiBhIHJhdyByZXF1ZXN0X3F1ZXVlIGFuZCB0byB0ZW1wb3Jh
cmlseSBhdm9pZA0KPiByZWZhY3RvcmluZyBzb21lIG5hc3R5IGNvZGUuDQo+IA0KPiBBbHNvIG1v
dmUgdGhlIGdmcF9tYXNrIGFyZ3VtZW50IGFmdGVyIHRoZSBucl92ZWNzIGFyZ3VtZW50IGZvciBh
IG11Y2gNCj4gbW9yZSBsb2dpY2FsIGNhbGxpbmcgY29udmVudGlvbiBtYXRjaGluZyB3aGF0IG1v
c3Qgb2YgdGhlIGtlcm5lbCBkb2VzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhl
bGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTog
Q2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0K
