From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 07/29] target/iblock: use bdev_nr_sectors instead of open
 coding it
Date: Wed, 13 Oct 2021 22:37:47 +0000
Message-ID: <a225b3d3-372a-9804-374f-936f8d91c553@nvidia.com>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-8-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5f6otzX/eXRYOTbYA6Fp/mgkxDWLzJRA9MtgNvJ2fk=;
 b=jnyvIjRMceCOQVoy0C+7er67MVrOBt7AazIqO4shXdhL4L8mWkpvY0Dvup/tvlpjVRxn3ZxnwABgr63UBtczKjWSXHP3JjnXFIw6uVflje1EXvNb8GVKicg2g/dE3eacI9TvHfak1efX5UiaF7BuVFkXEz91Ehxq3wgouVlIwpk5s/Yv4RvHAPVqP+BE5O1TGw2c21c8IMNzPIrgHaDNzCO/5mLH3xf9dcybUvmLEn9NbML26wbo0PDbDCsEpOSFwnhD8LtnrgFhU4g9lzcPENPvF5t03ITMsUEtKE+9zwdM1itkSvAM1/PIjwAtgrcmZLgr8rqb0ziAGkKpVZY26w==
In-Reply-To: <20211013051042.1065752-8-hch@lst.de>
Content-Language: en-US
Content-ID: <52B56D3B6B73B04C99CA63695B49537C@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, linux-raid@vger.kern

T24gMTAvMTIvMjAyMSAxMDoxMCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSB0
aGUgcHJvcGVyIGhlbHBlciB0byByZWFkIHRoZSBibG9jayBkZXZpY2Ugc2l6ZS4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCg0KQm9k
bydzIGNvbW1lbnQgaXMgZ29vZCBmb3IgdGhlIGNvZGUgcmVsaWFiaWxpdHkuDQoNCkVpdGhlciB3
YXksIGxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBu
dmlkaWEuY29tPg0KDQoNCg==
