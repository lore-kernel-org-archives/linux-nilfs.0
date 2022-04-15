From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 16/27] block: use bdev_alignment_offset in
 part_alignment_offset_show
Date: Fri, 15 Apr 2022 05:43:53 +0000
Message-ID: <d4d70cec-aaef-27bd-4d29-7382a740f192@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-17-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBkQBjRSn9XGMGFyMCBwAEJr7XdtAp3lo0AoSBJHgvo=;
 b=TD25AIYRb8iwCA9fahL99Olp9+/Hgztmyc7Cke/aNxVFMkYqgPmEKIa0h9K26Lizf8FQtbpJ6ZrI43SRYXUa/IEilbPb/yWrsMWKkvVMTb5eGrmKtloM/HeeGoLG/okNV7PxpECiAiiYRo9oQlbfjDmkiuiTM6mgxRU4PVVmr6RXqlPoiVfxAOLCq44bzbjr04GIsU+i+wkYwmXqFd8z069t2I0ex/3qnxQewZ5y7zNzeShvVEPpwZo9kcCoprtQzOE532RcrC4q5AQc5fs0lnzBrqkQUccvapN4PmMnK+mDecb7Qq3G0+gQfrs7UHiuHRUHtlqVG0C/W5DVaZuTUQ==
In-Reply-To: <20220415045258.199825-17-hch@lst.de>
Content-Language: en-US
Content-ID: <082F7C538FC35349BB8BF71526006F64@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "nbd@other.debian.org" <nbd@other.debian.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>

T24gNC8xNC8yMiAyMTo1MiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFJlcGxhY2UgdGhl
IG9wZW4gY29kZWQgb2Zmc2V0IGNhbGN1bGF0aW9uIHdpdGggdGhlIHByb3BlciBoZWxwZXIuDQo+
IFRoaXMgaXMgYW4gQUJJIGNoYW5nZSBpbiB0aGF0IHRoZSAtMSBmb3IgYSBtaXNhbGlnbmVkIHBh
cnRpdGlvbiBpcw0KPiBwcm9wZXJseSBwcm9wYWdhdGVkLCB3aGljaCBjYW4gYmUgY29uc2lkZXJl
ZCBhIGJ1ZyBmaXggYW5kIG1hdGNoZXMNCj4gd2hhdCBpcyBkb25lIG9uIHRoZSB3aG9sZSBkZXZp
Y2UuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4N
Cj4gUmV2aWV3ZWQtYnk6IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2VuQG9yYWNs
ZS5jb20+DQo+IC0tLQ0KDQpOZWF0IQ0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hh
aXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg==
