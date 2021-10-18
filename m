From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 26/30] ext4: use sb_bdev_nr_blocks
Date: Mon, 18 Oct 2021 05:48:50 +0000
Message-ID: <1e40ed5d-e21f-b435-a4e5-fddceb1aec98@nvidia.com>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-27-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUyTQ3VIv/3lTbE5TBzTeeZRTvN23XnlnIEuP/sUWvw=;
 b=mSNzowhUt565oO36dGskDEWnj46LesjzTOLmY8U46lTVCbpm4h9p2LKnhjcN5wkseKua9MsMw4pOGUGWC8jA3v8kwE2VLN0mNuhokACVw/NhumCh35226wUSASkk8mYGkRYGmUfvSOCb6d1JRoKhmltYHW8W+5bj4cIEjQsBUxcs49tflrgf7iYee48oBGB/+dTmu8E05iGXNnuH9oJ1DVldJ/Phd1B3zI5SIRi1DgJ3hZAG+pFkEg7GHtM9KFKXfHyO+0+ctd+HXWVm+9o14IROCRmMtdkqsOQR+nrIN4vjfKIP/SBhuxuOfDKYsKUqCsuZXQTfIoDB/coHIaoWvA==
In-Reply-To: <20211015132643.1621913-27-hch@lst.de>
Content-Language: en-US
Content-ID: <BCC697D6D15CC447B9C6C8675F0B9C0F@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, linux-raid@vger.kern

T24gMTAvMTUvMjEgMDY6MjYsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBVc2UgdGhlIHNi
X2JkZXZfbnJfYmxvY2tzIGhlbHBlciBpbnN0ZWFkIG9mIG9wZW4gY29kaW5nIGl0Lg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IFJldmlld2Vk
LWJ5OiBLZWVzIENvb2sgPGtlZXNjb29rQGNocm9taXVtLm9yZz4NCj4gUmV2aWV3ZWQtYnk6IEph
biBLYXJhIDxqYWNrQHN1c2UuY3o+DQo+IEFja2VkLWJ5OiBUaGVvZG9yZSBUcydvIDx0eXRzb0Bt
aXQuZWR1Pg0KPg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGth
cm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KDQo=
