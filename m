From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Inquiry: disk format change in the future
Date: Wed, 19 Aug 2009 22:55:39 -0500
Message-ID: <4A8CC93B.9090904@redhat.com>
References: <20090820002457.A0C0520E21@spam-fw.osrg.net>
	<20090820.112237.04623349.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090820.112237.04623349.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

Ryusuke Konishi wrote:
> (reply added to "Yann E. MORIN")
> 
> Hi,
> On Wed, 19 Aug 2009 11:31:56 +0200, "Yann E. MORIN" wrote:
>> Hello All!
>>
>> I've searched the archives, but could not find the answer to the
>> following questions:
>>
>>  - will there be, or what is the probability of, a disk format change
>>    in the near future (few months)?
> 
> We still have some possibilities for the format change at this time.
> 
> Basically I intend to keep the disk format, but some new features like
> 
> - Extended attributes, ACLs
> - Rollback
> - Checkpoint based remote replication
> 
> may require it.  So far, we haven't seen any specific requisition.
>  

Do you expect that any of the changes may impact the ability of
utilities such as blkid or file to recognize a nilfs filesystem?

I'd happily write patches for those utilities to add nilfs recognition
if you think there is a stable fingerprint that can be recognized.

Thanks,
-Eric
