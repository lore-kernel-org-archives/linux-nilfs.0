From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 22/30] reiserfs: use bdev_nr_bytes instead of open coding
 it
Date: Mon, 18 Oct 2021 06:22:30 +0000
Message-ID: <16eaa7bd-3f47-47ef-2cbe-ae7f50779e56@nvidia.com>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-23-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkKpSR1al2VUo6bot/ISgx0uzk3S61wFAi4ja6KZrqQ=;
 b=dpa1tMZQ9fZx0+VFd0OtjNnzxqJkTGEeMLAs6FNB09l8Fj6c4idPEUZ7FnaJ+LDfVnoKgE2qp22h1Sn6LFfEbRMlXZuPoEDJzOQZns3nLnvvhT0Jk2LPOlBn+9e9h4PCfMMSWEINo7DiLpDYuTUrQsRNw/S1pdB4rMZIUNNSXB636LB/1nLJoHbESBMpzVL0M7R0dD4FwXEn0dJzaiA6Wy4ieo+fLFOTao8J1jPVD7oy6x2BAARs/j3pgfTKjNRIWgbgq79ZpF/UxWWTCeecyq2ppbEIkYl4ARMMbGzySbmFiN8hvY1pEc8quqj6eW+aWAAs4bXdbkbuwo+/KJXNsg==
In-Reply-To: <20211015132643.1621913-23-hch@lst.de>
Content-Language: en-US
Content-ID: <1D52234084563549BE0202AC74D36824@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, linux-raid@vger.kern

T24gMTAvMTUvMjEgMDY6MjYsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBVc2UgdGhlIHBy
b3BlciBoZWxwZXIgdG8gcmVhZCB0aGUgYmxvY2sgZGV2aWNlIHNpemUgYW5kIHJlbW92ZSB0d28N
Cj4gY2FyZ28gY3VsdGVkIGNoZWNrcyB0aGF0IGNhbid0IGJlIGZhbHNlLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IFJldmlld2VkLWJ5OiBK
YW4gS2FyYSA8amFja0BzdXNlLmN6Pg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hh
aXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KDQo=
