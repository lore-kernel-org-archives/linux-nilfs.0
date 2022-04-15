From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 24/27] block: remove QUEUE_FLAG_DISCARD
Date: Fri, 15 Apr 2022 05:47:45 +0000
Message-ID: <0bf7bda0-0c19-7186-8492-ad894456d98d@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-25-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yccX0Ck38D03COpr5o1/1QaWpsfoh5G/DeZ7DRwbxA=;
 b=eexxlZfYMjmAdwt+eDdwGqGoSYW67KO1NX9sKkqRDCqyY6hBFpyBG+BpU+2/e7y7pWsF9bCw+rrqnt3vqhBdk7UFPEhEK6KOIRAYQsnOGAeT2l8jFcYcHUD9WieOuybNERv2EYDzEuZQ/N4THg5CILJmeXucz0BocQG462XQzWLIltv3jqhHaHzhPGaKxU/U9EdvRnZlHVUN57vzdDLRTmxYMdtUEhBY4IcaeLLCiIuhhWf+AaJs/GQADZOhGnvfvFDCMkD9MdnMzTwEVFj+4cHzzy/VTaNWnqS739bzw3BHJt+LWtQIDD9LcA0Q2eWKw05BiPxioGGadwmKdTVB7g==
In-Reply-To: <20220415045258.199825-25-hch@lst.de>
Content-Language: en-US
Content-ID: <B35E75958048F04C98F125EEE4A4B3F7@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "nbd@other.debian.org" <nbd@other.debian.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>

T24gNC8xNC8yMiAyMTo1MiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEp1c3QgdXNlIGEg
bm9uLXplcm8gbWF4X2Rpc2NhcmRfc2VjdG9ycyBhcyBhbiBpbmRpY2F0b3IgZm9yIGRpc2NhcmQN
Cj4gc3VwcG9ydCwgc2ltaWxhciB0byB3aGF0IGlzIGRvbmUgZm9yIHdyaXRlIHplcm9lcy4NCj4g
DQo+IFRoZSBvbmx5IHBsYWNlcyB3aGVyZSBuZWVkcyBzcGVjaWFsIGF0dGVudGlvbiBpcyB0aGUg
UkFJRDUgZHJpdmVyLA0KPiB3aGljaCBtdXN0IGNsZWFyIGRpc2NhcmQgc3VwcG9ydCBmb3Igc2Vj
dXJpdHkgcmVhc29ucyBieSBkZWZhdWx0LA0KPiBldmVuIGlmIHRoZSBkZWZhdWx0IHN0YWNraW5n
IHJ1bGVzIHdvdWxkIGFsbG93IGZvciBpdC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9w
aCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiBSZXZpZXdlZC1ieTogTWFydGluIEsuIFBldGVyc2Vu
IDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4NCj4gQWNrZWQtYnk6IENocmlzdG9waCBCw7Zo
bXdhbGRlciA8Y2hyaXN0b3BoLmJvZWhtd2FsZGVyQGxpbmJpdC5jb20+IFtkcmJkXQ0KPiBBY2tl
ZC1ieTogSmFuIEjDtnBwbmVyIDxob2VwcG5lckBsaW51eC5pYm0uY29tPiBbczM5MF0NCj4gQWNr
ZWQtYnk6IENvbHkgTGkgPGNvbHlsaUBzdXNlLmRlPiBbYmNhY2hlXQ0KPiBBY2tlZC1ieTogRGF2
aWQgU3RlcmJhIDxkc3RlcmJhQHN1c2UuY29tPiBbYnRyZnNdDQo+IC0tLQ0KDQoNCkxvb2tzIGdv
b2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0K
DQotY2sNCg0KDQo=
