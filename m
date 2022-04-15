From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 01/27] target: remove an incorrect unmap zeroes data
 deduction
Date: Fri, 15 Apr 2022 05:36:12 +0000
Message-ID: <673afa25-cf3f-616c-6bcd-16de35b307b2@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-2-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4IuTuVb/KyS1ZV0aqxRI/Yu1yD+ABTgelallVeHsTxk=;
 b=lx/vsdq1wuVjGXFb0RtlS8aNQVUdAwD32nu7CMFt+qyOZp4fU3BYd3nAfXUFYKskrRJfQL7Sgji53ElZm5sqH6S/Ro6ASYp2RNr5+WHyhQPl3V6ohDw/8K2T39LgGqYhL4BcILkZlIF3ghKn0878TKS0ZcvZmL9PLTjfMTSIQNzECGhofyqMeQ+XUOAPN0Q3qU8PzNiUwWiOS3ftFL8yvZ1G2R/FHpEDy1mrydwcAu2LEF+6QmWcTz3dW09SMVJheytf97BROBR4O2mgsLrGBQYZ8LvNMcZhgPtxqrDaz2MjJwXa5Np6BaGNWj9+2NWfTymrAIM8L/TicDPywpv7Gg==
In-Reply-To: <20220415045258.199825-2-hch@lst.de>
Content-Language: en-US
Content-ID: <E802A778DDA3DB47923030D024586109@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "nbd@other.debian.org" <nbd@other.debian.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>

T24gNC8xNC8yMiAyMTo1MiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEZvciBibG9jayBk
ZXZpY2VzLCB0aGUgU0NTSSB0YXJnZXQgZHJpdmVycyBpbXBsZW1lbnRzIFVOTUFQIGFzIGNhbGxz
IHRvDQo+IGJsa2Rldl9pc3N1ZV9kaXNjYXJkLCB3aGljaCBkb2VzIG5vdCBndWFyYW50ZWUgemVy
b2luZyBqdXN0IGJlY2F1c2UNCj4gV3JpdGUgWmVyb2VzIGlzIHN1cHBvcnRlZC4NCj4gDQo+IE5v
dGUgdGhhdCB0aGlzIGRvZXMgbm90IGFmZmVjdCB0aGUgZmlsZSBiYWNrZWQgcGF0aCB3aGljaCB1
c2VzDQo+IGZhbGxvY2F0ZSB0byBwdW5jaCBob2xlcy4NCj4gDQo+IEZpeGVzOiAyMjM3NDk4ZjBi
NWMgKCJ0YXJnZXQvaWJsb2NrOiBDb252ZXJ0IFdSSVRFX1NBTUUgdG8gYmxrZGV2X2lzc3VlX3pl
cm9vdXQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4N
Cj4gUmV2aWV3ZWQtYnk6IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2VuQG9yYWNs
ZS5jb20+DQoNCk5vdCBhIGdvb2QgYXNzdW1wdGlvbiB0byBoYXZlIGZvciBzdXJlLg0KDQpMb29r
cyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNv
bT4NCg0KLWNrDQoNCg0K
