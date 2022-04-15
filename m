From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 11/27] block: add a bdev_nonrot helper
Date: Fri, 15 Apr 2022 05:41:25 +0000
Message-ID: <eba999b5-e9fc-1522-67dd-e232b48be9c4@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-12-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzXz3EW8164cUoT21ZBUSUoZ9U90cZUmBkouo2Rft2s=;
 b=bGHX/fV6uJIpyCR2p2PaPG9oBWBEvVWfxrceGopaEEh4AETPGGtfSzbwP3/8gUrk1TdOjJGM7AaoEAjY0DQkOp8XY2tsTP26SrWcsmOFe15NJaW+XmVxFL6N82mgoyPNAT0dvPGmhE73zLaS6Xvw9HWDTAiduFRGVeU13ZU/ALibmVm5mPwujCQ+y06Zn1tHHc241PNquirvyc6UHc2gtlggT45ZBFfw8/dgbrWJroQy7f2eDsPUatZzuIVq/LfnaO8Rrf1vBJCy8Kzakbef0ePwgeXIrVtXF/Lil/8oPzyddYcm4P6BcKj14UIuMGss9Hz8CF6QNKLxXNOl5WdpOw==
In-Reply-To: <20220415045258.199825-12-hch@lst.de>
Content-Language: en-US
Content-ID: <78329BCB58D5BB408C7439FBB9C8189D@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "nbd@other.debian.org" <nbd@other.debian.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>

T24gNC8xNC8yMiAyMTo1MiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFkZCBhIGhlbHBl
ciB0byBjaGVjayB0aGUgbm9ucm90IGZsYWcgYmFzZWQgb24gdGhlIGJsb2NrX2RldmljZSBpbnN0
ZWFkDQo+IG9mIGhhdmluZyB0byBwb2tlIGludG8gdGhlIGJsb2NrIGxheWVyIGludGVybmFsIHJl
cXVlc3RfcXVldWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNo
QGxzdC5kZT4NCj4gUmV2aWV3ZWQtYnk6IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFydGluLnBldGVy
c2VuQG9yYWNsZS5jb20+DQo+IEFja2VkLWJ5OiBEYXZpZCBTdGVyYmEgPGRzdGVyYmFAc3VzZS5j
b20+IFtidHJmc10NCj4gLS0tDQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFu
eWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQoNCg==
