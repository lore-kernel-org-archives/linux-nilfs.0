From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 0/2] nilfs2: using nobarrier option
 instead of barrier=off
Date: Wed, 11 Nov 2009 21:03:52 +0900 (JST)
Message-ID: <20091111.210352.22528384.ryusuke@osrg.net>
References: <1257930258-3106-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1257930258-3106-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi!
On Wed, 11 Nov 2009 18:04:16 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi,
> 
> This is a series of patches to use nobarrier mount option
> instead of barrier=off, for most of fs using nofoobar style option.
> 
> First patch is the actual patch to modify the mount option.
> 
> Second patch is cleanup patch to remove unused match_bool() function
> as a result of modifying mount option.
> 
>  fs/nilfs2/super.c |   28 +++++-----------------------
>  1 files changed, 5 insertions(+), 23 deletions(-)

Well, this change looks quite reasonable, and also helps to resolve
the discordance between the old barrier option and standard linux
options; it also matches the "-o norepair" which I posted recently.

Although the first patch changes user-interface, I believe the impact
is limited because the barrier feature is enabled by default.

So, I'd like to apply your change unless someone dissents.

Sekiba-san, could you modify Documentation/filesystems/nilfs2.txt and
include it in the first patch?

The doc file has description on mount options.

Thanks,
Ryusuke Konishi
