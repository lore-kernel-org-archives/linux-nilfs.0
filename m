From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: nilfs_check_page: bad entry in directory #37945
Date: Mon, 16 Mar 2009 11:49:32 +0100
Message-ID: <20090316104932.GA7773@aardappel.13thmonkey.org>
References: <49BE2765.2050200@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <49BE2765.2050200-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Dear David,

On Mon, Mar 16, 2009 at 11:18:13AM +0100, David Arendt wrote:
> Hi,
> 
> this morning I discovered this in /var/log/messages
> 
> Mar 16 10:59:00 server NILFS error (device sda3): nilfs_check_page: bad
> entry in directory #37945: unaligned directory entry - offset=0,
> inode=1919250021, rec_len=14411, name_len=67

Fun! the offset is fine but i think it complains about the record length...
sounds like a bug to me, but others might shed more light on it. On the
question if it can be harmfull, well maybe on directory appending but even so
it might autocorrect(ed) it?

With regards,
Reinoud
