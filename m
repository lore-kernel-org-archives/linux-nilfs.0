From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 0/3] v3: write_super clean up
Date: Thu, 23 Jul 2009 02:06:05 +0900 (JST)
Message-ID: <20090723.020605.118916792.ryusuke@osrg.net>
References: <1248252323-22959-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1248252323-22959-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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

Hi,
On Wed, 22 Jul 2009 17:45:20 +0900, Jiro SEKIBA wrote:
> Hi, this is re-revised version of write_super clean up patch.
> 
> This time, 3rd one removed nilfs_write_super out.
> 
> Any comments and suggestions are appreciate.
> 
> Thanks,
> 
> Regards,
> --
> Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

I've queued this in the experimental tree.

Thank you for your help!

Ryusuke Konishi

>  fs/nilfs2/segment.c   |    7 +++++-
>  fs/nilfs2/super.c     |   61 +++++++-----------------------------------------
>  fs/nilfs2/the_nilfs.h |   14 +++++++++++
>  3 files changed, 29 insertions(+), 53 deletions(-)
